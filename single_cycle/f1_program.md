# F1 Program

```cpp
void vbdBar(int v) {    // turn LED RED according to 8 bit value (1 = ON)
  char msg[80];    // max 80 characters
  std::sprintf(msg, "$B,%d\n", v); 
  serial.writeString(msg); ack();
}
```

After consulting the 'vbuddy.cpp' header file we realised the output would require 8-bits to control the neopixels and in order for the F1 lights to increment accordingly we would require some shifting and adding. 

Through several iterations we finalised on the ```ADD``` and ```ADDI``` to shift the bits to the left once and add 1 to turn on a neopixel. 

The code therefore looked as such:

```
start:
    addi a0, x0, 0     # Initialize a0 to 0
    addi a1, x0, 0     # Initialize temp register a1 to 0
    addi t1, x0, 255   # Compare value for reset

loop:
    add a1, a1, a1     # Shift left logical (multiply by 2) the value in a1
    addi a1, a1, 1     # Increment the value in a1
    addi a0, a1, 0     # Add the value in a1 to a0
    beq a0, t1, reset  # Branch to reset if a0 equals t1 (255)
    beq a0, a0, loop   # Jump back to the beginning of the loop

reset:
    addi a0, x0, 0     # Set a0 to 0
    addi a1, x0, 0     # Set a1 to 0
    jal loop           # Jump back to the main loop
```

We had also realised that we had to use a "temporary" register to do the operations of shifting and adding as otherwise it would not be transitioning to a new pixel ```ON``` everytime as it would shift the neopixel. By setting the value of a0<-a1 at the end of the function it allowed for smooth functionality. 

Although we could have implemented ```SLLI``` to shift the bits we initially did not have this speicfic instruction implemented and therefore could not use it. So we ended up using an equivalent existing alternative.

Even though we could have optimised the program by getting rid of the reset subroutine but we deemed it sensible to add due to the ```JAL``` instruction being used for further testing.