function lookahead(p::MyMDPProblemModel, U::Vector{Float64}, s::Int64, a::Int64)

    # grab stuff from the problem -
    R = p.R;  # reward -
    T = p.T;    
    γ = p.γ;
    𝒮 = p.𝒮;
    
    # setup my state array -
    return R[s,a] + γ*sum(T[s,s′,a]*U[i] for (i,s′) in enumerate(𝒮))
end

function lookahead(p::MyMDPProblemModel, U::Function, s::Int64, a::Int64)

    # get data from the problem -
    𝒮, T, R, γ = p.𝒮, p.T, p.R, p.γ;
    return R(s,a) + γ*sum(T(s,s′,a)*U(s′) for s′ in 𝒮)
end

function iterative_policy_evaluation(p::MyMDPProblemModel, π, k_max::Int)

    # grab stuff from the problem -
    R = p.R;  # reward -
    T = p.T;    
    γ = p.γ;
    𝒮 = p.𝒮;

    # initialize value -
    U = [0.0 for s ∈ 𝒮];

    for _ ∈ 1:k_max
        U = [lookahead(p, U, s, π(s)) for s ∈ 𝒮]
    end

    return U;
end

function Q(p::MyMDPProblemModel, U::Array{Float64,1})::Array{Float64,2}

    # grab stuff from the problem -
    R = p.R;  # reward -
    T = p.T;    
    γ = p.γ;
    𝒮 = p.𝒮;
    𝒜 = p.𝒜

    # initialize -
    Q_array = Array{Float64,2}(undef, length(𝒮), length(𝒜))

    for s ∈ 1:length(𝒮)
        for a ∈ 1:length(𝒜)
            Q_array[s,a] = R[s,a] + γ*sum([T[s,s′,a]*U[s′] for s′ in 𝒮]);
        end
    end

    return Q_array
end

function policy(Q_array::Array{Float64,2})::Array{Int64,1}

    # get the dimension -
    (NR, _) = size(Q_array);

    # initialize some storage -
    π_array = Array{Int64,1}(undef, NR)
    for s ∈ 1:NR
        π_array[s] = argmax(Q_array[s,:]);
    end

    # return -
    return π_array;
end

function backup(problem::MyMDPProblemModel, U::Array{Float64,1}, s::Int64)
    return maximum(lookahead(problem, U, s, a) for a ∈ problem.𝒜);
end

function solve(model::MyValueIterationModel, problem::MyMDPProblemModel)::MyValueFunctionPolicy
    
    # data -
    k_max = model.k_max;

    # initialize
    U = [0.0 for _ ∈ problem.𝒮];

    # main loop -
    for _ ∈ 1:k_max
        U = [backup(problem, U, s) for s ∈ problem.𝒮];
    end

    return MyValueFunctionPolicy(problem, U);
end

function greedy(problem::MyMDPProblemModel, U::Array{Float64,1}, s::Int64)
    u, a = findmax(a->lookahead(problem, U, s, a), problem.𝒜);
    return (a=a, u=u)
end

(π::MyValueFunctionPolicy)(s::Int64) = greedy(π.problem, π.U, s).a;

function rollout(problem::MyMDPProblemModel, s::Int64, policy::Function, depth::Int64)::Float64

    # initialize -
    ret = 0.0;
    for i ∈ 1:depth
        a = policy(s);
        s, r = randstep(problem, s, a);
        ret += problem.γ^(i-1)*r;
    end
    return ret;
end

randstep(problem::MyMDPProblemModel, s::Int64, a::Int64)::Int64 = problem.TR(s,a)

function (π::MyRolloutLookaheadModel)(s::Int64)
    U(s) = lookahead(π.problem, s, π.policy, π.depth);
    return greedy(π.problem, U, s).a;
end
