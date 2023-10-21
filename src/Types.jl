abstract type AbstractUtilityFunctionType end
abstract type AbstractChoiceModelType end
abstract type AbstractBehaviorModelType end
abstract type AbstractSimpleChoiceProblem end
abstract type AbstractStochasticChoiceProblem end
abstract type AbstractGameModel end
abstract type AbstractPolicyModel end
abstract type AbstractProcessModel end
abstract type AbstractWorldModel end
abstract type AbstractLearningModel end

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

# ===== GAMES ==================================================================== #

"""
    Models simple games for Multiagent Reinforcement Learning and Reasoning

This implemention was reporduced from the Algorithms for Decision Making book by Mykel J. Kochenderfer and Tim A. Wheeler.
"""
mutable struct MySimpleGameModel <: AbstractGameModel

    # data -
    γ   # discount factor -
    ℐ   # set of players -
    𝒜   # joint action space
    R   # joint reward function

    # # constructor -
    MySimpleGameModel() = new();
end

mutable struct MyMDPProblemModel <: AbstractProcessModel

    # data -
    𝒮::Array{Int64,1}
    𝒜::Array{Int64,1}
    T::Union{Function, Array{Float64,3}}
    TR::Union{Function, Nothing}
    R::Union{Function, Array{Float64,2}}
    γ::Float64
    
    # constructor -
    MyMDPProblemModel() = new()
end

struct MyIteratedBestResponsePolicy <: AbstractPolicyModel 
    k_max # number of iterations
    π     # initial policy
end

mutable struct MySimpleGamePolicy <: AbstractPolicyModel

    # data -
    p # dictionary mapping actions to probabilities

    # constrcutors -
    function MySimpleGamePolicy(p::Base.Generator)
        return MySimpleGamePolicy(Dict(p))
    end

    function MySimpleGamePolicy(p::Dict)
        vs = collect(values(p));
        vs ./= sum(vs);
        return new(Dict(k => v for (k,v) ∈ zip(keys(p), vs)))
    end

    function MySimpleGamePolicy(aᵢ)
        return MySimpleGamePolicy(Dict(aᵢ => 1.0))
    end
end


mutable struct MyHierarchicalSoftmaxPolicy
    
    # data
    λ # precision parameter
    k # level
    π # initial policy

    # constructor -
    # MyHierarchicalSoftmaxPolicy() = new();
end

struct MyValueIterationModel 
    # data -
    k_max::Int64; # max number of iterations
end

struct MyValueFunctionPolicy
    problem::MyMDPProblemModel
    U::Array{Float64,1}
end

mutable struct MyRectangularGridWorldModel <: AbstractWorldModel

    # data -
    number_of_rows::Int
    number_of_cols::Int
    coordinates::Dict{Int,Tuple{Int,Int}}
    states::Dict{Tuple{Int,Int},Int}
    moves::Dict{Int,Tuple{Int,Int}}
    rewards::Dict{Int,Float64}

    # constructor -
    MyRectangularGridWorldModel() = new();
end

struct MyRolloutLookaheadModel <: AbstractLearningModel
    k_max::Int64
    policy::Array{Int64,1}
    d::Int64
end