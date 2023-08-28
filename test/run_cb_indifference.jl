# load the package -
using VLDecisionsPackage

# setup the call -
α = [0.4,0.6]
model = build(VLCobbDouglasUtilityFunction, (
    α = α,   
));


bounds = [
    1.0 10.0;
    1.0 10.0;
];

# call -
x = indifference(model, utility=Umax, bounds=bounds)

# setup bounds range -
# Δ = 0.05;
# number_of_steps = 100;
# L1 = 1.0;
# soln_array = Array{Float64,2}(undef, number_of_steps, 2);
# for i ∈ 1:number_of_steps

#     # create the bounds array -
#     bounds = [
#         L1 L1+Δ;
#         1.0 10.0;
#     ];

   

#     # capture -
#     soln_array[i,1] = x[1];
#     soln_array[i,2] = x[2];

#     # update the bound -
#     global L1 = L1 + Δ;
# end

