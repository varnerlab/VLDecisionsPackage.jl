abstract type AbstractUtilityFunctionType end
abstract type AbstractChoiceModelType end
abstract type AbstractBehaviorModelType end

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