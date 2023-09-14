"""
    solve(problem::MySimpleCobbDouglasChoiceProblem) -> Dict{String,Any}

Solves the optimal decision problem with a budget constraint with a Cobb-Douglas utility function
"""
function solve(problem::MySimpleCobbDouglasChoiceProblem)::Dict{String,Any}

    # initialize -
    results = Dict{String,Any}()
    α = problem.α;
    c = problem.c;
    bounds = problem.bounds;
    I = problem.I;
    xₒ = problem.initial

    # how many variables do we have?
    d = length(α);

    # Setup the problem -
    model = Model(()->MadNLP.Optimizer(print_level=MadNLP.INFO, max_iter=500))
    @variable(model, bounds[i,1] <= x[i=1:d] <= bounds[i,2], start=xₒ[i]) # we have d variables
    
    # set objective function -   
    @NLobjective(model, Max, (x[1]^α[1])*(x[2]^α[2]));
    @constraints(model, 
        begin
            # my budget constraint
            transpose(c)*x <= I
        end
    );

    # run the optimization -
    optimize!(model)

    # populate -
    x_opt = value.(x);
    results["argmax"] = x_opt
    results["budget"] = transpose(c)*x_opt; 
    results["objective_value"] = objective_value(model);

    # return -
    return results
end

"""
    solve(problem::MySimpleLinearChoiceProblem) -> Dict{String,Any}

Solves the optimal decision problem with a budget constraint using a Linear utility model
"""
function solve(problem::MySimpleLinearChoiceProblem)::Dict{String,Any}

    # initialize -
    results = Dict{String,Any}()
    α = problem.α;
    c = problem.c;
    bounds = problem.bounds;
    I = problem.I;
    xₒ = problem.initial

    # how many variables do we have?
    d = length(α);

    # Setup the problem -
    model = Model(GLPK.Optimizer)
    @variable(model, bounds[i,1] <= x[i=1:d] <= bounds[i,2], start=xₒ[i]) # we have d variables
    
    # set objective function -   
    @objective(model, Max, transpose(α)*x);
    @constraints(model, 
        begin
            # my budget constraint
            transpose(c)*x <= I
        end
    );

    # run the optimization -
    optimize!(model)

    # populate -
    x_opt = value.(x);
    results["argmax"] = x_opt
    results["budget"] = transpose(c)*x_opt; 
    results["objective_value"] = objective_value(model);

    # return -
    return results
end

"""
    solve(problem::MySimpleBinaryVariableLinearChoiceProblem) -> Dict{String,Any}

Solves the optimal decision problem with a budget constraint using a Linear utility model, 
and binary feature variables
"""
function solve(problem::MySimpleBinaryVariableLinearChoiceProblem)::Dict{String,Any}

    # initialize -
    results = Dict{String,Any}()
    α = problem.α;
    c = problem.c;
    bounds = problem.bounds;
    I = problem.I;
    xₒ = problem.initial
    

    # how many variables do we have?
    d = length(α);

    # additional constraints -
    C = problem.C
    bV = nothing
    if (isnothing(C) == true)
        
        C = zeros(d,d);
        for i ∈ 1:d
            C[i,i] = 1;
        end
        bV = ones(d);
    else
        bV = ones(size(C,1));
    end


    # Setup the problem -
    model = Model(GLPK.Optimizer)
    @variable(model, bounds[i,1] <= x[i=1:d] <= bounds[i,2], start=xₒ[i], Bin) # we have d- binary variables
    
    # set objective function -   
    @objective(model, Max, transpose(α)*x);
    @constraints(model, 
        begin
            
            # my budget constraint
            transpose(c)*x <= I
            C*x <= bV

            # we can only choose one feature
            # x[1] + x[2] <= 1
            # x[3] + x[4] + x[5] + x[6] <= 1
        end
    );

    # run the optimization -
    optimize!(model)

    # populate -
    x_opt = value.(x);
    results["argmax"] = x_opt
    results["budget"] = transpose(c)*x_opt; 
    results["objective_value"] = objective_value(model);

    # return -
    return results
end

function solve(problem::MyMarkowitzRiskyAssetOnlyPortfiolioChoiceProblem)::Dict{String,Any}

    # initialize -
    results = Dict{String,Any}()
    Σ = problem.Σ;
    μ = problem.μ;
    R = problem.R;
    bounds = problem.bounds;
    wₒ = problem.initial

    # setup the problem -
    d = length(μ)
    model = Model(()->MadNLP.Optimizer(print_level=MadNLP.ERROR, max_iter=500))
    @variable(model, bounds[i,1] <= w[i=1:d] <= bounds[i,2], start=wₒ[i])

    # set objective function -
    @objective(model, Min, transpose(w)*Σ*w);

    # setup the constraints -
    @constraints(model, 
        begin
            # my turn constraint
            transpose(μ)*w >= R
            sum(w) == 1.0
        end
    );

    # run the optimization -
    optimize!(model)

    # populate -
    w_opt = value.(w);
    results["argmax"] = w_opt
    results["reward"] = transpose(μ)*w_opt; 
    results["objective_value"] = objective_value(model);
    results["status"] = termination_status(model);

    # return -
    return results
end

function solve(problem::MyMarkowitzRiskyRiskFreePortfiolioChoiceProblem)::Dict{String,Any}

    # initialize -
    results = Dict{String,Any}()
    Σ = problem.Σ;
    μ = problem.μ;
    R = problem.R;
    bounds = problem.bounds;
    initial = problem.initial
    rfr = problem.risk_free_rate

    # setup the problem -
    d = length(μ)
    model = Model(()->MadNLP.Optimizer(print_level=MadNLP.ERROR, max_iter=500))
    @variable(model, bounds[i,1] <= w[i=1:d] <= bounds[i,2], start=initial[i])

    # set objective function -
    @objective(model, Min, transpose(w)*Σ*w);

    # setup the constraints -
    @constraints(model, 
        begin
            # my turn constraint
            transpose(μ)*w + (1.0 - sum(w))*rfr >= R
        end
    );

    # run the optimization -
    optimize!(model)

    # populate -
    w_opt = value.(w);
    results["reward"] = transpose(μ)*w_opt + (1.0 - sum(w_opt))*rfr;
    results["argmax"] = w_opt;
    results["objective_value"] = objective_value(model);
    results["status"] = termination_status(model);

    # return -
    return results
end