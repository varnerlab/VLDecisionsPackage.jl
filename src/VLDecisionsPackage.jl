module VLDecisionsPackage

    # load the include file -
    include("Include.jl");
    
    # types -
    export AbstractUtilityFunctionType;
    export VLLinearUtilityFunction, VLCobbDouglasUtilityFunction, VLLeontiefUtilityFunction, VLLogUtilityFunction;

    # methods -
    export evaluate, indifference, build;
end
