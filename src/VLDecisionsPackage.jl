module VLDecisionsPackage

    # load the include file -
    include("Include.jl");
    
    # types -
    export AbstractUtilityFunctionType, AbstractChoiceModelType, AbstractBehaviorModelType;
    export VLLinearUtilityFunction, VLCobbDouglasUtilityFunction, VLLogTransformedCobbDouglasUtilityFunction, VLLeontiefUtilityFunction, VLLogUtilityFunction;
    export VLDiscreteChoiceModel;
    export VLLogitBehaviorModel;

    # methods -
    export evaluate, indifference, build, choose;
end
