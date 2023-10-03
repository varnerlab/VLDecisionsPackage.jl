(πᵢ::MySimpleGamePolicy)(aᵢ) = get(πᵢ.p, aᵢ, 0.0)

function (πᵢ::MySimpleGamePolicy)()
    D = SetCategorical(collect(keys(πᵢ.p)), collect(values(πᵢ.p)))
    return rand(D)
end

joint(X) = vec(collect(product(X...)))
joint(π, πᵢ, i) = [i == j ? πᵢ : πⱼ for (j, πⱼ) in enumerate(π)]

function utility(𝒫::MySimpleGameModel, π, i)
    𝒜, R = 𝒫.𝒜, 𝒫.R
    p(a) = prod(πⱼ(aⱼ) for (πⱼ, aⱼ) in zip(π, a))
    return sum(R(a)[i]*p(a) for a in joint(𝒜))
end

function best_response_policy(𝒢::MySimpleGameModel, π,i)
    U(ai) = utility(𝒢, joint(π, MySimpleGamePolicy(ai), i), i)
    ai = argmax(U, 𝒢.𝒜[i])
    return MySimpleGamePolicy(ai)
end

function softmax_response_policy(𝒢::MySimpleGameModel, π, i, λ)
    𝒜ᵢ = 𝒢.𝒜[i];
    U(aᵢ) = utility(𝒢, joint(π, MySimpleGamePolicy(aᵢ), i), i);
    return MySimpleGamePolicy(aᵢ => exp(λ*U(aᵢ)) for aᵢ in 𝒜ᵢ)
end

mutable struct MyFictitiousPlayModel
    𝒫  # simple game
    i  # agent index
    N  # array of action count dictionaries
    πi # current policy
end

function MyFictitiousPlayModel(𝒫::MySimpleGameModel, i)
    N = [Dict(aj => 1 for aj in 𝒫.𝒜[j]) for j in 𝒫.ℐ]
    πi = MySimpleGamePolicy(ai => 1.0 for ai in 𝒫.𝒜[i])
    return MyFictitiousPlayModel(𝒫, i, N, πi)
end

(πi::MyFictitiousPlayModel)() = πi.πi()
(πi::MyFictitiousPlayModel)(ai) = πi.πi(ai)

function update!(πi::MyFictitiousPlayModel, a)
    N, 𝒫, ℐ, i = πi.N, πi.𝒫, πi.𝒫.ℐ, πi.i
    for (j, aj) in enumerate(a)
        N[j][aj] += 1
    end
    p(j) = MySimpleGamePolicy(aj => u/sum(values(N[j])) for (aj, u) in N[j])
    π = [p(j) for j in ℐ]
    πi.πi = best_response_policy(𝒫, π, i)
end

function simulate(𝒫::MySimpleGameModel, π, k_max)
    for k = 1:k_max
        a = [πi() for πi in π]
        for πi in π
            update!(πi, a)
        end
    end
    return π
end


# function HierarchicalSoftmaxPolicy(𝒫::MySimpleGameModel, λ, k)
#     π = [SimpleGamePolicy(ai => 1.0 for ai in 𝒜i) for 𝒜i in 𝒫.𝒜]
#     return MyHierarchicalSoftmaxPolicy(λ, k, π)
# end

function solve(M::MyHierarchicalSoftmaxPolicy, 𝒫)
    π = M.π
    for k in 1:M.k
        π = [softmax_response_policy(𝒫, π, i, M.λ) for i in 𝒫.ℐ]
    end
    return π
end