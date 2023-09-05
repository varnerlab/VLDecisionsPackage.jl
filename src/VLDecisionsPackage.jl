module VLDecisionsPackage

    # load the include file -
    include("Include.jl");
    
    # types -
    export AbstractUtilityFunctionType, AbstractChoiceModelType, AbstractBehaviorModelType, AbstractSimpleChoiceProblem;
    export VLLinearUtilityFunction, VLCobbDouglasUtilityFunction, VLLogTransformedCobbDouglasUtilityFunction, VLLeontiefUtilityFunction, VLLogUtilityFunction;
    export VLDiscreteChoiceModel;
    export VLLogitBehaviorModel;

    # simple choice problems -
    export MySimpleCobbDouglasChoiceProblem
    export MySimpleLinearChoiceProblem

    # methods -
    export evaluate, indifference, build, choose, solve;
end
