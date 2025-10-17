# Setting up the environment

If you don't already have fypp installed (try *fypp* command to check) you can install it with pip:
```
pip3 install fypp
```

On belenos, fypp is available after loading the python/3.10.12

The official website is: [https://github.com/aradi/fypp](https://github.com/aradi/fypp)

And the official documentation is: [https://fypp.readthedocs.io/en/stable/](https://fypp.readthedocs.io/en/stable/)

# Introduction 

fypp is a preprocessor for Fortran, it aims to reduce the need to write redundant code. In C++ you would use the template system to achieve that goal, but with fypp we will use python code. You can visualize fypp as a python script which works is to print or generate Fortran code.

# Ex1 First run with fypp

Create a new file named ex1.fypp. Add a python for-loop that range from 1 to 10 and print that number.Try to run this script with python: ```python3 ex1.fypp```

We will now modify this python script into an fypp script. The python for-loop will looks extremely similar to the standard python loop. The differences to have it run with fypp is that the line containing the *for* instruction must be prefixed with **#:** and the column at the end of line must be removed. Furthermore the loop must be closed with **#:endfor**

If you execute the script now with the command ```fypp ex1.fypp``` you should see the print command being 10 times. Notice that you really see the print command and not the value it prints (the variable i). We have asked fypp to show ten times this print command.

But we want to generate Fortran code, so replace this print command with ```write(*,*) i```
Rerun the fypp command to check the result.

Now we want to print the content of the python variable *i*, not the literal character i. To do so we need to tell fypp to interpret a part of the line. If we add **#:** at the beginning of the line it would try to interpret the whole write statement, but we just want to interpret *i*. To do so you must enclosed it with **\$\{** and **\}\$**. So if the variable is called index you will have to write **\$\{index\}\$**.

Check that it works with the command:
```
fypp ex1.fypp
```

If it works, you should see ten lines of Fortran code in your terminal.

Add a ```program``` statement and ``end program`` statement before the for loop to generate a complete working Fortran program. Run fypp and try to compile the generated code to check that it works.

# Ex2 - Creating a 'generic' subroutine by generating all possibilities

1. Create a new module and in the *contains* section write a Fortran subroutine named *print_value_integer* that takes an *integer* in input and print that number to stdout. In the same file, do the same for *real* and *double precision*.

In another file, add a main program to use the module and call the subroutines.

2. Add a generic interface in the module before the contains, so that in the main you don't need to call *print_value_integer* or *print_value_real* but only *print_value*.

```
interface print_value
  procedure :: print_value_integer, print_value_real, print_value_double_precision
end interface print_value
```

Compile it and check that you only need to call *print_value* whatever the type.

3. Now use the fypp directives to remove the redundancy. Instead of writing three times the same subroutine, write a fypp for-loop that generates the three subroutines. The content of the subroutine will be almost the same Fortran code appart the type of the input variable that you will declare by using a fypp variable.

# Ex 3 - Macro definition

Take the exercise 2 source code and copy it under a new name. Now, instead of using *real* and *double precision* we want to use only real but with different kinds: *sp* and *dp*. We want to generate the code for each one only the corresponding macro is given at the generation step (eg. ```fypp ex3.fypp -DSP```). Make it works when either one or the two case are defined.

In the fypp code you can check if the macro is defined with:
```
#:if defined('SP')
 ! do something here
#:endif
```

Don't forget it should also works for integer.

# Ex 4 - Using variables and inline python code

Use fypp to generate a module that contains the three subroutines. Each subroutine will takes an array of integer which dimensions are either 3 or 5 or 8 and prints its values. Finally add the generic interface so they all can be called from the same name.

To define variables with fypp:
```
#:def dimensions = [3,5,8]
```

To use python code inline, enclose it with **\$\{** and **\}\$** like the variables:
```
character :: ${str(d).upper()$}
```
