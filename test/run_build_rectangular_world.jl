# load the package -
using VLDecisionsPackage

# Step 1: Build a model of the world -
number_of_rows = 4
number_of_cols = 4

# setup rewards -
rewards = Dict{Tuple{Int,Int}, Float64}()
rewards[(2,2)] = -100000.0 # lava is the (2,2) square 
rewards[(3,3)] = 1000.0    # target square

# setup set of absorbing states -
absorbing_state_set = Set{Tuple{Int,Int}}()
push!(absorbing_state_set, (2,2));
push!(absorbing_state_set, (3,3));

# call the factory -
world_model = build(MyRectangularGridWorldModel, (
    nrows = number_of_rows, ncols = number_of_rows, rewards = rewards, defaultreward = -1.0
));