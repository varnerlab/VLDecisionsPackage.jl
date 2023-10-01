# setup my paths -
const _PATH_TO_SRC = dirname(pathof(@__MODULE__));

# load external dependencies -
using Distributions
using Optim
using MadNLP
using JuMP
using GLPK
using LinearAlgebra
using GridInterpolations

# load my codes -
include(joinpath(_PATH_TO_SRC, "Types.jl"));
include(joinpath(_PATH_TO_SRC, "Factory.jl"));
include(joinpath(_PATH_TO_SRC, "Compute.jl"));
include(joinpath(_PATH_TO_SRC, "Choice.jl"));
include(joinpath(_PATH_TO_SRC, "Indifference.jl"));
include(joinpath(_PATH_TO_SRC, "Solve.jl"));
include(joinpath(_PATH_TO_SRC, "Utility.jl"));
include(joinpath(_PATH_TO_SRC, "Games.jl"));