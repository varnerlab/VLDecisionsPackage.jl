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

function best_response(𝒢::MySimpleGameModel, π,i)
    U(aᵢ) = utility(𝒢, joint(π, MySimpleGamePolicy(aᵢ), i), i);
    aᵢ = argmax(U, 𝒢.𝒜[i]);
    return MySimpleGamePolicy(aᵢ)
end

function softmax_response(𝒢::MySimpleGameModel, π, i, λ)
    𝒜ᵢ = 𝒢.𝒜[i];
    U(aᵢ) = utility(𝒢, joint(π, MySimpleGamePolicy(aᵢ), i), i);
    return MySimpleGamePolicy(aᵢ => exp(λ*U(aᵢ)) for aⱼ in 𝒜ᵢ)
end