function choose(choice::VLDiscreteChoiceModel, behavior::VLLogitBehaviorModel, 
    features::Array{T,2})::Array{Float64,1} where T <: Real

    # initialize -
    model = choice.modes;
    scale = behavior.μ;
    (number_of_features, number_of_alternatives)  = size(features);
    probabilities = zeros(number_of_alternatives);

    # compute the probabilities -
    for i ∈ 1:number_of_alternatives
        probabilities[i] = exp((1.0/scale)*evaluate(model, features[:,i]));
    end

    # normalize -
    probabilities = probabilities ./ sum(probabilities);

    # return -
    return probabilities;
end