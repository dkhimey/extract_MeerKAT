include("globaltools.jl")

using Blio
using Printf
using .GlobalTools

# check user input of filename 
try global fbname, outname = ARGS[1], ARGS[2]
catch e
    throw(ArgumentError("Program expects file path argument (Ex: julia tool.jl file.fb outfile.fb)"))
end

# open file
fb = open(fbname)

# read header, generate Array
header = read(fb, Filterbank.Header)
data = Array(header)

# Take inputs
low_t = 
high_t = 
@printf("Select time interval between %i and %i LST\n", low_t, high_t)
println("Enter start time (Int64): ")
t1 = get_input(low_t, high_t)
println("Enter end time (Int64): ")
t2 = get_input(low_t, high_t)

nchan = 
@printf("Select frequency channel interval 1 to %i with central frequncy %f\n", nchan, header["OBSFREQ"])
println("Enter start channel (Int64): ")
f1 = get_input(1, nchan)
println("Enter end channel (Int64): ")
f2 = get_input(1, nchan)


# start writing new file
outfile = open(outname, "w")

# write new header
# !!!! should probably also edit header
write(outfile, header)

# read data
read!(fb, data)
maskdc!(fbd, 64)

