# load the package -
using VLDecisionsPackage

# setup the call -
Umax = 3.0;
α = [2.0,1.0];
model = build(VLLeontiefUtilityFunction, (
    α = α,    
));

# setup the bounds -
bounds = [
    0.0 10.0;
    0.0 10.0;
];

# call -
x = indifference(model, utility=Umax, bounds=bounds, ϵ = 1.0)