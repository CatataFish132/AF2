# import modules
using Plots
using XLSX

# read excel file
xf = XLSX.readxlsx("data.xlsx")
sh = xf["Sheet1"]
data = sh["A2:A1002"]

# KALMAN FILTERING
# VALUES
A = [1 0.1; 0 1]
B = [0.005; 0.1;;]
C = [1 0]
Sz = 100
Sw = [10^-6 2.10^-5; 2.10^-5 4.10^-4]
K = []

# INITIAL VALUES

U = 1
P = [[0.0 0.0; 0.0 0.0]]
X = [[0.0; 0.0;;]]
Y = vec(data)

# Kalman filter doing its thing

for k in 1:length(data)-1
    push!(K, A .* P[k] * transpose(C) * inv(C * P[k] * transpose(C) .+ Sz))
    push!(X, (A*X[k]+B*U) + K[k]*(Y[k+1] .- C*X[k]))
    push!(P, A*P[k]*transpose(A)+Sw-A*P[k]*transpose(C)*Sz^-1*C*P[k]*transpose(A))
end

# get position from the results
results = []
for x in X
    push!(results, ([0 1]*x)[1])
end

# plot results
t = 0:0.1:(length(data)-1)/10
plt = plot(t, results, title= "Kalman Filter", label="kalman filter")#, xlim=(0,10), ylim=(0,60))
# plot!(plt, t, vec(data), label="data")
xlabel!("Time(s)")
ylabel!("Speed(m/s)")
savefig("plot3.png")
@show plt

# make nice gif

plt = plot(
    2,
    xlim = (0,100),
    ylim = (0,60),
    title = "Kalman filter",
    label = ["kalman filter" "data"]
)

@gif for i=1:100
    push!(plt, [results[i]; data[i]])
end every 1

# write values to excel sheet

XLSX.openxlsx("data.xlsx", mode="rw") do xf
    sheet = xf["Sheet1"]
    sheet["C2:C1002"] = reshape(results, length(results), 1)
end