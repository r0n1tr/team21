# Mohammed Tayyab's Personal Statement

## Singl-cycle Processor

### F1 lighting machine code

To write the machine code for the F1 lighting sequence, I took inspiration from the finite state machine from lab 3

![Picture1](https://github.com/r0n1tr/team21/assets/133985295/99ac7227-d10d-43d9-88a2-8c25e61edff8)

One would think to do a loop where you do 

SLLI a0,a0,1

ADDI a0,a0,1

And repeat, no! After the left shift, the LSB of a0 is now 0, meaning the light at the very end of the f1 light is now closed. Sure, a clock cycle is short so no one would notice the difference. However, if this were implemented on a real f1 traffic light, and someone noticed the light turning off, they’d think the problem is with the light itself. To avoid this, the following measures were taken.

<img width="218" alt="Picture2" src="https://github.com/r0n1tr/team21/assets/133985295/db31e364-511f-465a-ade6-2c1303c2c125">

As you can see on the left, a temporary register, t1, was used. This way, the LSB of a0 won’t be after consecutive left shifts. The LSB of t1 will be 0, but that doesn’t matter since the f1 lights are connected to register a0.

### Trigger and Reset

<img width="245" alt="Picture3" src="https://github.com/r0n1tr/team21/assets/133985295/5047ff36-411a-4192-9f02-622f96c5dc7d">














