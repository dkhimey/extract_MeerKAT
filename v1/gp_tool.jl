include("globaltools.jl")

using Blio
using Printf
using .GlobalTools
using BenchmarkTools

# check user input of filename 
try global rawname, outname = ARGS[1], ARGS[2]
catch e
    throw(ArgumentError("Program expects file path argument (Ex: julia tool.jl file.raw outfile.raw)"))
end

# open file
raw = open(rawname)

# Read GUPPI RAW header so we can make data Array
header = read(raw, GuppiRaw.Header)
data = Array(header)

# Take inputs
low_t = header["lst"]
high_t = low_t + header["SCANLEN"]
@printf("Select time interval between %i and %i LST\n", low_t, high_t)
println("Enter start time (Int64): ")
t1 = get_input(low_t, high_t)
println("Enter end time (Int64): ")
t2 = get_input(low_t, high_t)

nchan = header["OBSNCHAN"]
@printf("Select frequency channel interval 1 to %i with central frequncy %f\n", nchan, header["OBSFREQ"])
println("Enter start channel (Int64): ")
f1 = get_input(1, nchan)
println("Enter end channel (Int64): ")
f2 = get_input(1, nchan)

# Reposition the `raw` IO stream back to the beginning of the file
seekstart(raw)

# start writing new file
outfile = open(outname, "w")

# time this section
@time begin
    while read!(raw, header)
        read!(raw, data)
        # check if time falls on interval 
        # !!!! something to worry about later: what happens if user flips inputs?
        if header["lst"] <= t2 && header["lst"] >= t1
            # write new header
            # !!!! edit header
            write(outfile, header)
            # write data from spcified channels
            write(outfile, data[:, :, f1:f2])
        else
        end
    end
end