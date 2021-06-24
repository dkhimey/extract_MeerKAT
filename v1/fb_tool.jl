include("globaltools.jl")

using Blio
using Printf
using .GlobalTools
using BenchmarkTools

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
low_t = header["tstart"]
nsamps = header["nsamps"]
dt = header["tsamp"]
high_t = low_t + dt * nsamps
@printf("File contains %i time samples. \nObservations available from %.2f to %.2f in increments of %.2f.\n", nsamps, low_t, high_t, dt)
@printf("Select time index between %i and %i\n.", 1, nsamps)
println("Enter start index (Int64): ")
t1 = get_input(1, nsamps)
println("Enter end index (Int64): ")
t2 = get_input(1, nsamps)

nchans = header["nchans"]
@printf("Select frequency channel interval 1 to %i\n", nchans)
println("Enter start channel (Int64): ")
f1 = get_input(1, nchans)
println("Enter end channel (Int64): ")
f2 = get_input(1, nchans)


# read data
read!(fb, data)
maskdc!(data, 64)

# start writing new file
outfile = open(outname, "w")
# write new header
# !!!! edit header
write(outfile, header)
# write data
write(outfile, data[f1:f2, :, t1:t2])
