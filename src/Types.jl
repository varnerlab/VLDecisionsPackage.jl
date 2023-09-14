abstract type AbstractUtilityFunctionType end
abstract type AbstractChoiceModelType end
abstract type AbstractBehaviorModelType end
abstract type AbstractSimpleChoiceProblem end
abstract type AbstractStochasticChoiceProblem end

# build concrete utility function types
mutable struct VLLinearUtilityFunction <: AbstractUtilityFunctionType
   
    # data -
    α::Union{Nothing, Array{Float64,1}} # parameters -

    # constructor -
    VLLinearUtilityFunction() = new()
end

mutable struct VLCobbDouglasUtilityFunction <: AbstractUtilityFunctionType
   
    # data -
    α::Union{Nothing, Array{Float64,1}} # parameters -

    # constructor -
    VLCobbDouglasUtilityFunction() = new()
end

mutable struct VLLogTransformedCobbDouglasUtilityFunction <: AbstractUtilityFunctionType
   
    # data -
    α::Union{Nothing, Array{Float64,1}} # parameters -
    b::Union{Nothing, Float64} # base of the log

    # constructor -
    VLLogTransformedCobbDouglasUtilityFunction() = new()
end

mutable struct VLLeontiefUtilityFunction <: AbstractUtilityFunctionType
   
    # data -
    α::Union{Nothing, Array{Float64,1}} # parameters -

    # constructor -
    VLLeontiefUtilityFunction() = new()
end

mutable struct VLLogUtilityFunction <: AbstractUtilityFunctionType
   
    # data -
    α::Union{Nothing, Array{Float64,1}} # parameters -
    β::Union{Nothing, Float64} # parameters -
    
    # constructor -
    VLLogUtilityFunction() = new()
end

mutable struct VLDiscreteChoiceModel <: AbstractChoiceModelType
   
    # data -
    model::AbstractUtilityFunctionType # utility function -
    
    # constructor -
    VLDiscreteChoiceModel() = new()
end

struct VLLogitBehaviorModel <: AbstractBehaviorModelType

    # data -
    μ::Float64 # scale parameter -
      
    # constructor -
    VLLogitBehaviorModel() = new()
end

mutable struct MySimpleCobbDouglasChoiceProblem <: AbstractSimpleChoiceProblem

    # data -
    α::Array{Float64,1}
    c::Array{Float64,1}
    I::Float64
    bounds::Array{Float64,2}
    initial::Array{Float64,1}

    # constructor
    MySimpleCobbDouglasChoiceProblem() = new();
end

mutable struct MySimpleLinearChoiceProblem <: AbstractSimpleChoiceProblem

    # data -
    α::Array{Float64,1}
    c::Array{Float64,1}
    I::Float64
    bounds::Array{Float64,2}
    initial::Array{Float64,1}

    # constructor
    MySimpleLinearChoiceProblem() = new();
end

mutable struct MySimpleBinaryVariableLinearChoiceProblem <: AbstractSimpleChoiceProblem

    # data -
    α::Array{Float64,1}
    c::Array{Float64,1}
    I::Float64
    bounds::Array{Int64,2}
    initial::Array{Int64,1}
    C::Union{Nothing, Array{Int64,2}}

    # constructor
    MySimpleBinaryVariableLinearChoiceProblem() = new();
end

mutable struct MyMarkowitzRiskyAssetOnlyPortfiolioChoiceProblem <: AbstractStochasticChoiceProblem

    # data -
    Σ::Array{Float64,2}
    μ::Array{Float64,1}
    bounds::Array{Float64,2}
    R::Float64
    initial::Array{Float64,1}

    # constructor
    MyMarkowitzRiskyAssetOnlyPortfiolioChoiceProblem() = new();
end

mutable struct MyMarkowitzRiskyRiskFreePortfiolioChoiceProblem <: AbstractStochasticChoiceProblem

    # data -
    Σ::Array{Float64,2}
    μ::Array{Float64,1}
    bounds::Array{Float64,2}
    R::Float64
    initial::Array{Float64,1}
    risk_free_rate::Float64

    # constructor -
    MyMarkowitzRiskyRiskFreePortfiolioChoiceProblem() = new();
end