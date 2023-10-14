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

function build(model::Type{MyMDPProblemModel}, data::NamedTuple)::MyMDPProblemModel
    
    # build an empty model -
    m = MyMDPProblemModel();

    # get data from the named tuple -
    haskey(data, :𝒮) == false ? m.𝒮 = Array{Int64,1}(undef,1) : m.𝒮 = data[:𝒮];
    haskey(data, :𝒜) == false ? m.𝒜 = Array{Int64,1}(undef,1) : m.𝒜 = data[:𝒜];
    haskey(data, :T) == false ? m.T = Array{Float64,3}(undef,1,1,1) : m.T = data[:T];
    haskey(data, :R) == false ? m.R = Array{Float64,2}(undef,1,1) : m.R = data[:R];
    haskey(data, :γ) == false ? m.γ = 0.1 : m.γ = data[:γ];
    
    # return -
    return m;
end