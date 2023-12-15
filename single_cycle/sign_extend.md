# Sign Extend

### Purpose 

To produce a 32-bit sign-extended immediate from the immediate value within an instruction.

### Inputs

- `[31:0] instr` - 32-bit instruction word
- `[2:0]  immsrc` - Indicates instruction type, and hence which bits of the instruction contain which parts of the immediate

### Outputs

- `[31:0] immext` - 32-bit sign-extended immediate operand

### Implementation notes

There are six instruction types to concern ourselves with: `R`, `I`, `S`, `B`, `J`, and `U`. 

R-types do not have immediates, so this module doesn't need to do anything with them.

U-type immediates don't need to be sign extended, but instead placed on the most significant 5 bytes of `immext`. It is just convenient to do that here.

For the rest of the instruction types, the immediates are arragned differently and have different sizes depending on the instruction type. We assemble the bits bespokely for each case by performing bit manipulation. In order to perform sign extension, we simply duplicate the most signifcant bit of the immediate (which is also the MSB of `instr`) as many times as needed for the final immediate to be of size 32 bits.