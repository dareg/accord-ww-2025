# Field API hands-on

## Installation

To do this hands-on you will need to compile and install Field API with the NVHPC compiler. You will need to install fiat first.

Fiat: [https://github.com/ACCORD-NWP/fiat](https://github.com/ACCORD-NWP/fiat)

Field API: [https://github.com/ecmwf-ifs/field_api](https://github.com/ecmwf-ifs/field_api)

## Ex 1 - Wrapper, Owner

Field API provides two way of encapsulating data: field\_owner and field\_wrapper. The field owners are data that are entirely managed by field API, while field owner let the user encapsulates data that already exists.

To create a field owner or a field wrapper, you must first declare a variable of type field\_NTYPE (eg. FIELD\_2RB, FIELD\_4PIM...) and then use the *field_new* subroutine to initialise it. The argument you use in field\_new will decide if you are initialising a field\_owner or a field\_wrapper.

Initialisation a 2D field wrapper named FW with a pre-existing 2D array named TEMPERATURES:
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

Field API handle the details of how to transfer the data on the GPU but you still need to tell when you would like the data to be transfered. To do so, you will use one of the following subroutines:

```
SUBROUTINE GET_DEVICE_DATA_RDONLY (SELF, PPTR)
SUBROUTINE GET_DEVICE_DATA_RDWR (SELF, PPTR)
SUBROUTINE GET_HOST_DATA_RDONLY (SELF, PPTR)
SUBROUTINE GET_HOST_DATA_RDWR (SELF, PPTR)
```
Notice those subroutines are methods to call on a field object. The PPTR argument is a pointer to the raw data on CPU (HOST) or GPU (DEVICE) that you will use for the computations.

Modify the program of the first exercice to add some data transfer. Compile and check that the transfers are really happening with the nvprof tool.

## Ex 3 - Storing and accessing multiples blocks in a field

## Ex - Encapsulating a derived datatype to field API

Download the code from URL

In this exercice you will encapsulate a derived datatype already used in a codebase. The exercice is inspired by real work we are doing on IAL.
The type you will encapsulate is TTRC and is defined in the yomtrc, it's initialisation is in init\_ttrc and it's destruction is in clean\_data. On top of the encapsulation you will have to lean the code base and add proper method on the type and call them instead of the disparate subroutines we have here.

1. Modify the TTRC type in order to:
  - Add the correct field\_api type for each element of TTRC. The dimension of the field type will be the original dimension of the array plus one to store all the blocks.
	  For instance,the corresponding field type for GRSURF is FIELD_3RB.
	- Add a pointer to each member with the same original dimension, it will be used in update view to point on a specific block, and then in the computation to access the data.
2. Reimplement the initialisation in the init\_ttrc method
3. Reimplement the destruction in the final\_ttrc method
4. Implement the update view method. In the method you will make each pointer point to a specific block part of the field type.
4. Maybe use fypp to remove some redundancy in some of the methods.

