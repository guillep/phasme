# Phasme

A x86-64 learning compiler.

It features:
 - an x86 ASM generator
 - a Mach-o reader to load the compiled ASM (compiled through gcc)
 - a simple simulator based on unicorn
 - a simple stack based compiler that
    - implements arithmetics, control flow, function calls
    - implements the System V calling convention for up to 2 arguments
    - stores intermediate values in the stack and sub-utilised registers (on purpose :))

Coming:
 - a debugger and disassembler
 - management of arrays and structures
 - a bit on parsing either using Smacc as a grammar-based parser generator, or petit parser using parser combinators, or both

## Dependencies

The pharo dependencies are already specified in the baseline. Load the project in iceberg and then install through metacello.
However, this requries installing two native libraries: 
 - llvm, for the disassembler
 - unicorn, for the simulation

Download libllvm-full and libunicorn from the following and put them next to the image or VM.:
 - Linux, x86-64: https://files.pharo.org/vm/pharo-spur64/Linux-x86_64/third-party/
 - OSX, x86-64: https://files.pharo.org/vm/pharo-spur64/Darwin-x86_64/third-party/

CAUTION: only tested on OSX for now
