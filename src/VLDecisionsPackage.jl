module VLDecisionsPackage

    # load the include file -
    include("Include.jl");
    
    # types -
    export AbstractUtilityFunctionType, AbstractChoiceModelType, AbstractBehaviorModelType, AbstractSimpleChoiceProblem, AbstractGameModel, AbstractPolicyModel;
    export AbstractProcessModel, AbstractWorldModel, AbstactLearningModel;
    export VLLinearUtilityFunction, VLCobbDouglasUtilityFunction, VLLogTransformedCobbDouglasUtilityFunction, VLLeontiefUtilityFunction, VLLogUtilityFunction;
    export VLDiscreteChoiceModel;
    export VLLogitBehaviorModel;

    # simple choice problems -
    export MySimpleCobbDouglasChoiceProblem
    export MySimpleLinearChoiceProblem
    export MySimpleBinaryVariableLinearChoiceProblem

    # stochastic choice problems -
    export AbstractStochasticChoiceProblem
    export MyMarkowitzRiskyAssetOnlyPortfiolioChoiceProblem
    export MyMarkowitzRiskyRiskFreePortfiolioChoiceProblem

    # games -
    export MySimpleGamePolicy, MySimpleGameModel, SetCategorical, MyFictitiousPlayModel
    export MyHierarchicalSoftmaxPolicy
    export MyIteratedBestResponsePolicy
    
    # MDPs
    export MyMDPProblemModel, MyValueIterationModel, MyValueFunctionPolicy, MyRectangularGridWorldModel, MyRolloutLookaheadModel
    export lookahead, iterative_policy_evaluation, Q, policy, backup, rollout;

    # methods -
    export evaluate, indifference, build, choose, solve, greedy;
    export best_response_policy, softmax_response_policy, joint, utility, simulate, update!
end
