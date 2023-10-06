function _build(modeltype::Type{T}, data::NamedTuple) where T <: Union{AbstractUtilityFunctionType, AbstractSimpleChoiceProblem, AbstractStochasticChoiceProblem}
    
    # build an empty model
    model = modeltype();

    # if we have options, add them to the contract model -
    if (isempty(data) == false)
        for key ∈ fieldnames(modeltype)
            
            # check the for the key - if we have it, then grab this value
            value = nothing
            if (haskey(data, key) == true)
                # get the value -
                value = data[key]
            end

            # set -
            setproperty!(model, key, value)
        end
    end
 
    # return -
    return model
end

# functions -
build(model::Type{VLLinearUtilityFunction}, data::NamedTuple)::VLLinearUtilityFunction = _build(model, data)

build(model::Type{VLCobbDouglasUtilityFunction}, data::NamedTuple)::VLCobbDouglasUtilityFunction = _build(model, data)
build(model::Type{VLLogTransformedCobbDouglasUtilityFunction}, data::NamedTuple)::VLLogTransformedCobbDouglasUtilityFunction = _build(model, data)

build(model::Type{VLLeontiefUtilityFunction}, data::NamedTuple)::VLLeontiefUtilityFunction = _build(model, data)
build(model::Type{VLLogUtilityFunction}, data::NamedTuple)::VLLogUtilityFunction = _build(model, data)
build(model::Type{VLDiscreteChoiceModel}, data::NamedTuple)::VLDiscreteChoiceModel = _build(model, data)
build(model::Type{VLLogitBehaviorModel}, data::NamedTuple)::VLLogitBehaviorModel = _build(model, data);
build(model::Type{MySimpleCobbDouglasChoiceProblem}, data::NamedTuple)::MySimpleCobbDouglasChoiceProblem = _build(model, data);
build(model::Type{MySimpleLinearChoiceProblem}, data::NamedTuple)::MySimpleLinearChoiceProblem = _build(model, data);
build(model::Type{MySimpleBinaryVariableLinearChoiceProblem}, data::NamedTuple)::MySimpleBinaryVariableLinearChoiceProblem = _build(model, data);
build(model::Type{MyMarkowitzRiskyAssetOnlyPortfiolioChoiceProblem}, data::NamedTuple)::MyMarkowitzRiskyAssetOnlyPortfiolioChoiceProblem = _build(model, data);
build(model::Type{MyMarkowitzRiskyRiskFreePortfiolioChoiceProblem}, data::NamedTuple)::MyMarkowitzRiskyRiskFreePortfiolioChoiceProblem = _build(model, data);
build(model::Type{MySimpleGameModel}, data::NamedTuple)::MySimpleGameModel = _build(model, data);


function build(𝒫::MySimpleGameModel, k_max)
    π = [MySimpleGamePolicy(ai => 1.0 for ai in 𝒜i) for 𝒜i in 𝒫.𝒜]
    return MyIteratedBestResponsePolicy(k_max, π)
end