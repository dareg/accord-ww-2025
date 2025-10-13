# Ex1 First run with fypp

Create a new file named ex1.fypp. Add a for-loop that range from 1 to 10. The python for-loop will looks extremely similar to the standard python loop. The differences to have it run with fypp is that the line must be prefixed with *#:* and the for-loop doesn't have a column at the end of line and the loop must be closed with *#:endfor*

Inside this loop add a write statement in fortran to print the index. To use the value of the fypp variable inside the fortran code, you must enclosed it with *${* and *}$*. So if the variable is called index you will have to write *${index}$*.

Check that it works with the command:
```
fypp ex1.fypp
```

If it works, you should see ten lines of fortran code in your terminal.

# Ex2 - Generating subroutines with for multiple types

1. Create a new module and the contains write a fortran subroutine named *print_value_integer* that takes an *integer* in input and print that number to stdout. In the same file, do the same for *real* and *double precision*.

In another file, add a main program that use the module and call the subroutines.

2. Add a generic interface in the module before the contains, so that in the main you don't need to call *print_value_integer* or *print_value_real* but only *print_value*.

```
interface print_value
  procedure :: print_value_integer, print_value_real, print_value_double_precision
end interface print_value
```

Compile it and check that you only need to call *print_value* whatever the type.

3. Now use the fypp directives to remove the redundancy. Instead of writing three times the same subroutine, write a fypp for-loop that generates the three subroutines. The content of the subroutine will be essetialy the same appart the type of the input variable that you will declare by using a fypp variable.

Ex 3 - 
