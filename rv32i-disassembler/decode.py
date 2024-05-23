import sys
import argparse
from opcodes import *

def decode_rv32(reg, verbose, jump = False):
    """
    Decode RV32 instruction
    """
    l = list(bin(int(reg, 16))[2:]) # convert to list

    l = ['0' for _ in range(32 - len(l))] + l # fill the beginning with 0s
    opcode = l[-7:] # last 7 bits

    handler, instr = rv32m_opcodes.get(int(''.join(opcode), 2), (None, None))
    if handler is None:
        return None, None

    return handler(l, instr, verbose, jump)

def main():
    parser = argparse.ArgumentParser(prog='decode.py', description='Simple RV32 decompiler')
    parser.add_argument('-v', '--verbose', action='store_true', help='verbose output')
    parser.add_argument('register', help='register to decode (or file)', metavar='register/file')
    args = parser.parse_args()
    
    if args.register[:2] == "0x":
        ans, jump = decode_rv32(args.register, args.verbose)
        if ans is None:
            print("Could not decode")
        else:
            print(ans)

    else:
        with open(args.register, 'r') as f:
            lines = f.readlines()
        f = open("instructions.txt", "w")
        f.write("")
        f.close()
        f = open("instructions.txt", "a")
        for l in lines:
            if "00000000" in l:
                print("END OF INSTRUCTIONS")
                f.write("END OF INSTRUCTIONS\n")
                break
            ans, jump = decode_rv32("0x"+l, args.verbose)
            if ans is None:
                print("Could not decode")
                f.write("Could not decode\n")
            else:
                print(ans)
                f.write(ans+"\n")
        f.close()

if __name__ == "__main__":
    main()

