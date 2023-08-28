function _obj_function(x, utility, model)::Float64

    # evaluate the utility model -
    U_model = evaluate(model, x);

    # compute the error -
    error = (U_model - utility).^2;

    # return -
    return error;
end


### ===== PUBLIC METHODS BELOW HERE ============================================================================================= ###
"""
    indifference(model::VLLinearUtilityFunction; 
        utility::Float64=1.0, dependent::Array{Float64,2}) -> Array{Float64,2}
"""
# function indifference(model::VLLinearUtilityFunction; 
#     utility::Float64=1.0, dependent::Array{T,2})::Array{Float64,2} where T <: Real

#     # get parameters from model -
#     α = model.α;
#     number_of_goods = length(α);
#     number_of_steps = size(dependent, 1);
#     solution = zeros(number_of_steps, number_of_goods);
#     β = α[1:(end-1)];

#     # initialize -
#     bV = zeros(number_of_steps);

#     # build right-hand side -
#     for i ∈ 1:number_of_steps
#         bV[i] = utility - sum(β.*dependent[i,:]);
#     end

#     # build the matrix -
#     A = zeros(number_of_steps, number_of_steps);
#     for i ∈ 1:number_of_steps
#         A[i,i] = α[end];
#     end

#     # solve -
#     x = A\bV;

#     # package up -
#     for i ∈ 1:number_of_steps
#        for j ∈ 1:number_of_goods-1
#            solution[i,j] = dependent[i,j];
#        end
#     end

#     for i ∈ 1:number_of_steps
#         solution[i,number_of_goods] = x[i];
#     end

#     # return - 
#     return solution;
# end

function indifference(model::VLLinearUtilityFunction; 
    utility::Float64=1.0, bounds::Array{T,2}, ϵ::Float64 = 0.01) where T <: Real

    # how many steps are we going to take?
    number_of_steps = Int(floor((bounds[1,end] - bounds[1,1])/ϵ));
    number_of_features = size(bounds, 1);
    solution = zeros(number_of_steps, number_of_features);

    # setup the optimizer -
    inner_optimizer = NelderMead()
    obj_function(x) =  _obj_function(x, utility, model)

    base = bounds[1,1];
    for i ∈ 1:number_of_steps
    
        # formulate the bounds -
        tmp_bounds = zeros(number_of_features, 2);
        
        for j ∈ 1:number_of_features
            
            if (j == 1)
                tmp_bounds[j,1] = base;
                tmp_bounds[j,2] = base + ϵ;
            else
                tmp_bounds[j,1] = bounds[j,1];
                tmp_bounds[j,2] = bounds[j,2];
            end
        end

        # setup the IC -
        L = tmp_bounds[:,1];
        U = tmp_bounds[:,2];
        xₒ = (L .+ U)./2.0;

        # setup optimizer, objective function and solve -
        results = optimize(obj_function, L, U, xₒ, Fminbox(inner_optimizer),
            Optim.Options(time_limit = 600, show_trace = false, iterations=100))

        # grab the best parameters -
        x_best = Optim.minimizer(results)

        # add to solution -
        solution[i,:] .= x_best;

        # update the base -
        base += ϵ;
    end

    # return -
    return solution
end


function indifference(model::VLCobbDouglasUtilityFunction; 
    utility::Float64=1.0, bounds::Array{T,2}, ϵ::Float64 = 0.01) where T <: Real

    # how many steps are we going to take?
    number_of_steps = Int(floor((bounds[1,end] - bounds[1,1])/ϵ));
    number_of_features = size(bounds, 1);
    solution = zeros(number_of_steps, number_of_features);

    # setup the optimizer -
    inner_optimizer = NelderMead()
    obj_function(x) =  _obj_function(x, utility, model)

    base = bounds[1,1];
    for i ∈ 1:number_of_steps
    
        # formulate the bounds -
        tmp_bounds = zeros(number_of_features, 2);
        
        for j ∈ 1:number_of_features
            
            if (j == 1)
                tmp_bounds[j,1] = base;
                tmp_bounds[j,2] = base + ϵ;
            else
                tmp_bounds[j,1] = bounds[j,1];
                tmp_bounds[j,2] = bounds[j,2];
            end
        end

        # setup the IC -
        L = tmp_bounds[:,1];
        U = tmp_bounds[:,2];
        xₒ = (L .+ U)./2.0;

        # setup optimizer, objective function and solve -
        results = optimize(obj_function, L, U, xₒ, Fminbox(inner_optimizer),
            Optim.Options(time_limit = 600, show_trace = false, iterations=100))

        # grab the best parameters -
        x_best = Optim.minimizer(results)

        # add to solution -
        solution[i,:] .= x_best;

        # update the base -
        base += ϵ;
    end

    # return -
    return solution
end

function indifference(model::VLLeontiefUtilityFunction; 
    utility::Float64=1.0, bounds::Array{T,2}, ϵ::Float64 = 0.01) where T <: Real

    # setup the x1, and x2 -
    x = range(bounds[1,1], bounds[1,2], step=ϵ) |> collect;
    y = range(bounds[2,1], bounds[2,2], step=ϵ) |> collect;
    
    # how many steps are we going to take?
    tmp = Dict{Int64, Tuple{Float64, Float64}}();

    # setup the solution -
    solnindex = 1
    for i ∈ eachindex(x)
        
        xvalue = x[i];

        for j ∈ eachindex(y)
            ylvalue = y[j];

            # compute the utility -
            U = evaluate(model, [xvalue, ylvalue]);

            # check if we are indifferent -
            if (U == utility)
                tmp[solnindex] = (xvalue, ylvalue);
                solnindex += 1;
            end
        end
    end

    # how many points do we have?
    number_of_solutions = length(tmp);
    solution = zeros(number_of_solutions, 2);
    for i ∈ 1:number_of_solutions
        solution[i,1] = tmp[i][1];
        solution[i,2] = tmp[i][2];
    end
   
    # return -
    return solution
end

### ===== PUBLIC METHODS ABOVE HERE ============================================================================================= ###
