# Simple RV32 instructions decoder
Adapted from https://github.com/enaix/simple-rv32-disassembler
I didn't actually verify it or look into how it works, just adapted it to parse program.hex 

## Usage
`python3 decode.py 0x00012345`

`python3 decode.py progam.hex`

If decoding a program hex file, it will write the instructions to instructions.txt

```
-v: print verbose register info
```
