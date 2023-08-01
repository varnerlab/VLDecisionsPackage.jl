# setup my paths -
const _PATH_TO_SRC = dirname(pathof(@__MODULE__));

# load external dependencies -
# fill me in

# load my codes -
include(joinpath(_PATH_TO_SRC, "Hello.jl"));
include(joinpath(_PATH_TO_SRC, "Types.jl"));
include(joinpath(_PATH_TO_SRC, "Factory.jl"));
include(joinpath(_PATH_TO_SRC, "Compute.jl"));