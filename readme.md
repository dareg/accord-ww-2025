# Fypp 

## Setting up the environment

If you don't already have fypp installed (try *fypp* command to check) you can install it with pip in a venv:
```
python3 -m venv venv
source venv/bin/activate
pip3 install fypp
```

On belenos, fypp is available after loading the python/3.10.12

The official website is: [https://github.com/aradi/fypp](https://github.com/aradi/fypp)

And the official documentation is: [https://fypp.readthedocs.io/en/stable/](https://fypp.readthedocs.io/en/stable/)

## Introduction 

fypp is a preprocessor for Fortran, it aims to reduce the need to write redundant code. In C++ you would use the template system to achieve that goal, but with fypp we will use python code. You can visualize fypp as a python script which works is to print or generate Fortran code.

## Ex1 First run with fypp

Create a new file named ex1.fypp. Add a python for-loop that range from 1 to 10 and print that number. Try to run this script with python: ```python3 ex1.fypp```

We will now modify this python script into an fypp script. The python for-loop will looks extremely similar to the standard python loop. The differences to have it run with fypp is that the line containing the *for* instruction must be prefixed with **#:** and the column at the end of line must be removed. Furthermore the loop must be closed with **#:endfor**

If you execute the script now with the command ```fypp ex1.fypp``` you should see the print command being displayed 10 times. Notice that you really see the print command and not the value it prints (the variable i). We have asked fypp to show ten times this print command.

But we want to generate Fortran code, so replace this print command with ```write(*,*) i```
Re-run the fypp command to check the result.

Now we want to print the content of the python variable *i*, not the literal character i. To do so we need to tell fypp to interpret a part of the line. If we add **#:** at the beginning of the line it would try to interpret the whole write statement, but we just want to interpret the variable *i*. To do so we must enclosed it with **\$\{** and **\}\$**. So if the variable is called index you will have to write ```${index}$```.

Check that it works with the command:
```
fypp ex1.fypp
```

If it works, you should see ten lines of Fortran code in your terminal.

Add a ```program``` statement and an ``end program`` statement before the for loop to generate a complete working Fortran program. Run fypp and try to compile the generated code to check that it works.

## Ex2 - Creating a 'generic' subroutine by generating all possibilities

1. Create a new Fortran module and in the *contains* section write a Fortran subroutine named *print_value_integer* that takes an *integer* in input and print that number to stdout. In the same file, do the same for *real* and *double precision*.

In another file, add a main program to use the module and call the subroutines.

2. Add a generic interface in the module before the contains, so that in the main you don't need to call *print_value_integer* or *print_value_real* but only *print_value*.

```
interface print_value
  procedure :: print_value_integer, print_value_real, print_value_double_precision
end interface print_value
```

Compile it and check that you only need to call *print_value* whatever the type.

3. Now use the fypp directives to remove the redundancy. Instead of writing three times the same subroutine, write a fypp for-loop that generates the three subroutines. The content of the subroutine will be almost the same Fortran code appart the type of the input variable that you will declare by using a fypp variable.

## Ex 3 - Macro definition

Take the exercise 2 source code and copy it under a new name. Now, instead of using *real* and *double precision* we want to use only real but with different kinds: *sp* and *dp*. We want to generate the code for each one only the corresponding macro is given at the generation step (eg. ```fypp ex3.fypp -DSP```). Make it works when either one or the two case are defined.

In the fypp code you can check if the macro is defined with:
```
#:if defined('SP')
 ! do something here
#:endif
```

Don't forget it should also works for integer.

## Ex 4 - Using variables and inline python code

Use fypp to generate a module that contains the three subroutines. Each subroutine will takes an array of integer which dimensions are either 3, 5 or 8 respectively and that prints the values in the array. Finally add the generic interface so they all can be called from the same name.

To define variables with fypp:
```
#:def dimensions = [3,5,8]
```

As before, to use python code inline, enclose it with **\$\{** and **\}\$** like the variables:
```
character :: ${str(d).upper()$}
```

## Ex 5 - It's just Python !

If you have complicated stuff to compute in the python code, it might be better to put it in it's own python file. To use it when running fypp you must give the path to the directory containing the modules with the option *-M* and use the option *-m* to specify which module you want to use. For instance:
```
fypp -m mymodule -M path/to/my/modules code_to_transform.fypp
```

Create a function in a new module and try to use it in your fypp macro.

# Field API

## Installation

To do this hands-on you will need to compile and install Field API with the NVHPC compiler. You will need to install fiat first.

Fiat: [https://github.com/ACCORD-NWP/fiat](https://github.com/ACCORD-NWP/fiat)

Field API: [https://github.com/ecmwf-ifs/field_api](https://github.com/ecmwf-ifs/field_api)

## Ex 1 - Wrapper, Owner

Field API provides two way of encapsulating data: field\_owner and field\_wrapper. The field owners are data that are entirely managed by field API, while field owner let the user encapsulates data that already exists.

To create a field owner or a field wrapper, you must first declare a variable of type field\_NTYPE (eg. FIELD\_2RB, FIELD\_4PIM...) and then use the *field_new* subroutine to initialize it. The argument you use in field\_new will decide if you are initializing a field\_owner or a field\_wrapper.

Initialization a 2D field wrapper named FW with a pre-existing 2D array named TEMPERATURES:
```
CLASS(FIELD_2RB), POINTER :: FW => NULL()
CALL FIELD_NEW(FW, DATA=TEMPERATURES)
```

Creation of a 2D field\_owner named FO of dimensions 1:10,1:10:
```
CLASS(FIELD_2RB), POINTER :: FO => NULL()
CALL FIELD_NEW(FO, /1,1/, /10,10/)
```

Don't forget to delete the data in either case with field\_delete.

Now try to write a small program that declare an array of type integer(kind=jpim), and put it in a field\ wrapper. Check that the program compiles.

## Ex 2 - Data transfers

Field API handle the details of how to transfer the data on the GPU but you still need to tell when you would like the data to be transferred. To do so, you will use one of the following subroutines:

```
SUBROUTINE GET_DEVICE_DATA_RDONLY (SELF, PPTR)
SUBROUTINE GET_DEVICE_DATA_RDWR (SELF, PPTR)
SUBROUTINE GET_HOST_DATA_RDONLY (SELF, PPTR)
SUBROUTINE GET_HOST_DATA_RDWR (SELF, PPTR)
```
Notice those subroutines are methods to call on a field object. The PPTR argument is a pointer to the raw data on CPU (HOST) or GPU (DEVICE) that you will use for the computations.

Modify the program of the first exercise to add some data transfer. Compile and check that the transfers are really happening with the nvprof tool.

## A word about block access with Field API

When creating a new field, by default the last dimension is used for the blocks. It means that when you create a new FIELD\_2RB you only get one 1D array to store the data, the last dimension being for the blocks. This last dimension is used in the OpenMP *parallel for* that loop over the blocks, and do the computation for each block. To select the block to do the computation on, the code will usually use the GET\_VIEW subroutine to select a specific block index in the field, see:

```
!$omp parallel do
DO BLK=1,BLKMAX
  PTR_ON_BLOCK => GET_VIEW(MYFIELD, BLK)
  CALL COMPUTE(PTR_ON_BLOCK)
ENDDO
```

It is possible to disable this functionality by passing the option PERSISTENT=.FALSE. when creating a new field.

## Ex 4 - Encapsulating a derived datatype in Field API

Download the code from URL

In this exercise you will encapsulate a derived datatype already used in a codebase. The exercise is inspired by real work we are doing on IAL.
The type you will encapsulate is TTRC and is defined in the yomtrc, it's initialization is in init\_ttrc and it's destruction is in clean\_data. On top of the encapsulation you will have to lean the code base and add proper method on the type and call them instead of the disparate subroutines we have here.

1. Modify the TTRC type in order to:
  - Add the correct field\_api type for each element of TTRC. The dimension of the field type will be the original dimension of the array plus one to store all the blocks. For instance,the corresponding field type for GRSURF is FIELD\_3RB.
  - Add a pointer to each member with the same original dimension, it will be used in update view to point on a specific block, and then in the computation to access the data.
2. Re-implement the initialization in the init\_ttrc method
3. Re-implement the destruction in the final\_ttrc method
4. Implement the update view method. In the method you will make each pointer point to a specific block part of the field type.
4. Maybe use fypp to remove some redundancy in some of the methods.

This exercise is a simplification of real work done to port some existing types to field API, see IAL [PR 300](https://github.com/ACCORD-NWP/IAL/pull/300) and [PR297](https://github.com/ACCORD-NWP/IAL/pull/297) to see the real exanples. 
