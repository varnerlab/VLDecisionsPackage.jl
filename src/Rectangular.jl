"""
    _update!(model::MyQLearningModel, data::NamedTuple) -> MyQLearninAgentModel
"""
function _world(model::MyRectangularGridWorldModel, s::Int, a::Int)::Tuple{Int,Float64}

    # initialize -
    s′ = nothing
    r = nothing
    
    # get data from the model -
    coordinates = model.coordinates;
    moves = model.moves
    states = model.states;
    rewards = model.rewards;
    number_of_rows = model.number_of_rows
    number_of_cols = model.number_of_cols

    # where are we now?
    current_position = coordinates[s];

    # get the perturbation -
    Δ = moves[a];
    new_position = current_position .+ Δ

    # before we go on, have we "driven off the grid"?
    if (new_position[1] >= 1 && new_position[1] <= number_of_rows 
        && new_position[2] >= 1 && new_position[2] <= number_of_cols)

        # lookup the new state -
        s′ = states[new_position];
        r = rewards[s′];
    else
       
        # ok: so we are all the grid. Bounce us back to to the current_position, and charge a huge penalty 
        s′ = states[current_position];
        r = -1000000.0
    end

    # return -
    return (s′,r);
end

# super cool hack -
(model::MyRectangularGridWorldModel)(s::Int, a::Int) = _world(model, s, a);