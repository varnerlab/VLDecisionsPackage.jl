# load the package -
using VLDecisionsPackage

# setup the call -
Umax = 2.0;
α = [0.4,0.6];
model = build(VLLinearUtilityFunction, (
    α = α,    
));

bounds = [
    0.0 Umax/α[1];
    0.0 Umax/α[2];
];

# call -
x = indifference(model, utility=Umax, bounds=bounds)