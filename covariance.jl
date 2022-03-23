using Random
using Distributions
using Statistics

# simulate data
A = Random.rand(Uniform(-0.2,0.2), 1000)
B = Random.rand(Uniform(-0.2,0.2), 1000)
C = Random.rand(Uniform(9.6,10.0), 1000)
data = [A B C]

# Calculate variance
function variance(data)
    data_mean = mean(data)
    sum((data[i] - data_mean)^2 for i in 1:length(data))/(length(data) - 1)
end

# Calculate covariance
function covariance(data1, data2)
    data1_mean = mean(data1)
    data2_mean = mean(data2)
    sum((data1[i] - data1_mean)*(data2[i] - data2_mean) for i in 1:length(data1))/(length(data1)-1)
end

# Calculate coveriance matrix
matrix = [variance(A) covariance(A,B) covariance(A,C);
        covariance(B,A) variance(B) covariance(B,C);
        covariance(C,A) covariance(C,B) variance(C)]

# Dislay Julia's Statistics package results and mine
display(cov(data))
display(matrix)