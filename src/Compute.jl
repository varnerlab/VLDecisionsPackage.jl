"""
    indifference(model::VLLinearUtilityFunction; 
        utility::Float64=1.0, dependent::Array{Float64,2}) -> Array{Float64,2}
"""
function indifference(model::VLLinearUtilityFunction; 
    utility::Float64=1.0, dependent::Array{T,2})::Array{Float64,2} where T <: Real

    # get parameters from model -
    α = model.α;
    number_of_goods = length(α);
    number_of_steps = size(dependent, 1);
    solution = zeros(number_of_steps, number_of_goods);
    β = α[1:(end-1)];

    # initialize -
    bV = zeros(number_of_steps);

    # build right-hand side -
    for i ∈ 1:number_of_steps
        bV[i] = utility - sum(β.*dependent[i,:]);
    end

    # build the matrix -
    A = zeros(number_of_steps, number_of_steps);
    for i ∈ 1:number_of_steps
        A[i,i] = α[end];
    end

    # solve -
    x = A\bV;

    # package up -
    for i ∈ 1:number_of_steps
       for j ∈ 1:number_of_goods-1
           solution[i,j] = dependent[i,j];
       end
    end

    for i ∈ 1:number_of_steps
        solution[i,number_of_goods] = x[i];
    end

    # return - 
    return solution;
end

"""
    evaluate(model::VLLinearUtilityFunction, dependent::Array{Float64,2}) -> Array{Float64,1}
"""
function evaluate(model::VLLinearUtilityFunction, dependent::Array{T,2})::Array{Float64,1} where T <: Real

    # get parameters from model -
    α = model.α;
    number_of_steps = size(dependent, 1);
    solution = zeros(number_of_steps);

    # build the solution -
    for i ∈ 1:number_of_steps
        solution[i] = sum(α.*dependent[i,:]);
    end

    # return - 
    return solution;
end

"""
    evaluate(model::VLLinearUtilityFunction, dependent::Array{Float64,1}) -> Array{Float64,1}
"""
function evaluate(model::VLLinearUtilityFunction, dependent::Array{T,1})::Array{Float64,1} where T <: Real

    # get parameters from model -
    α = model.α;
    number_of_steps = size(dependent, 1);
    solution = zeros(number_of_steps);

    # build the solution -
    for i ∈ 1:number_of_steps
        solution[i] = sum(α.*dependent[i,:]);
    end

    # return - 
    return solution;
end

"""
    evaluate(model::VLCobbDouglasUtilityFunction, dependent::Array{Float64,2}) -> Array{Float64,1}
"""
function evaluate(model::VLCobbDouglasUtilityFunction, dependent::Array{T,2})::Array{Float64,1} where T <: Real

    # get parameters from model -
    α = model.α;
    number_of_steps = size(dependent, 1);
    solution = zeros(number_of_steps);

    # build the solution -
    for i ∈ 1:number_of_steps
        solution[i] = prod(dependent[i,:] .^ α);
    end

    # return - 
    return solution;
end

function evaluate(model::VLCobbDouglasUtilityFunction, features::Array{Float64,1})::Float64

    # get parameters from model -
    α = model.α;
    number_of_features = size(features, 1);
    solution = zeros(number_of_features);

    # build the solution -
    for i ∈ 1:number_of_features
        solution[i] = features[i]^α[i];
    end

    # return - 
    return prod(solution);
end

    
"""
    evaluate(model::VLLeontiefUtilityFunction, dependent::Array{Float64,2}) -> Array{Float64,1}
"""
function evaluate(model::VLLeontiefUtilityFunction, dependent::Array{T,2})::Array{Float64,1} where T <: Real

    # get parameters from model -
    α = model.α;
    number_of_steps = size(dependent, 1);
    solution = zeros(number_of_steps);

    # build the solution -
    for i ∈ 1:number_of_steps
        solution[i] = minimum(dependent[i,:] ./ α);
    end

    # return - 
    return solution;
end


function evaluate(model::VLLeontiefUtilityFunction, dependent::Array{T,1})::Float64 where T <: Real

    # get parameters from model -
    α = model.α;

    # return - 
    return minimum(dependent[:,1] ./ α);
end

"""
    evaluate(model::VLLogUtilityFunction, dependent::Array{T,2}) -> Array{Float64,1} where T <: Real
"""
function evaluate(model::VLLogUtilityFunction, dependent::Array{T,2})::Array{Float64,1} where T <: Real

    # get parameters from model -
    α = model.α;
    β = model.β;
    number_of_steps = size(dependent, 1);
    solution = zeros(number_of_steps);

    # build the solution -
    for i ∈ 1:number_of_steps
        solution[i] = log(sum(α.*dependent[i,:]) + β);
    end

    # return - 
    return solution;
end

"""
    evaluate(model::VLLogUtilityFunction, dependent::Array{T,1}) -> Array{Float64,1} where T <: Real
"""
function evaluate(model::VLLogUtilityFunction, dependent::Array{T,1})::Array{Float64,1} where T <: Real

    # get parameters from model -
    α = model.α;
    β = model.β;
    number_of_steps = size(dependent, 1);
    solution = zeros(number_of_steps);

    # build the solution -
    for i ∈ 1:number_of_steps
        solution[i] = log(sum(α.*dependent[i,:]) + β);
    end

    # return - 
    return solution;
end