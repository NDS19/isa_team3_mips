# isa_team3_mips

Verilog MIPS CPU designed by Team 3 for the Instruction Architectures and Compilers
module from the 2nd year of Electronic and Information Engineering degree by
Imperial College London.

  Directory guide:
- docs - Contains the data-sheet detailing the individual components used to
make up the CPU and their purpose. Additionally, a diagram is included to
visualise the connections made between the verilog modules. Any additional
information such as timing analysis, cycle counts, smart implementations and the
approach used for testing is detailed here.

- rtl - Contains the main top-level verilog file making connections between the
main components that make up the CPU. Also contains display lines used to output
signal values to an output file for testing. The folder mips_cpu contains the .v
verilog files that make up the final product.

- test - The directory containing all files related to testing. Further readme's
are provided here within each subdirectory.
