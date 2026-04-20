%%%% Here is a modified numerical solver which applies Error_Normalizer to rescale the error.    
%%%% We found this algorithm has advantages when the counts detected in systems change dramatically. 
%%%% The results shown in the case study of three different cities in the manuscript does not apply this Error_Normalizer (i.e., Error_Normalizer = \vec 1)
%%%% To find the results in the these case studies, change the settings as follows:
%%%% (1) Error_Normalizer = [ones(N,1);ones(N,1)].   (2) let MAX_ERROR = 10. (3) Change the error to be sum(abs(ValueF).\Error_Normalizer) instead of max(abs(ValueF).\Error_Normalizer). 

function [P_M,O,D,flag_global,count_modified,error] = my_estimate_p_newton_new(A,count)

flag_global = 0;
flag = 0;

MAX_LITERATURE_STEP = 100;
MAX_STEP = 200;

N = size(A,1);

if size(count,1) == 1
    count = count';
end

% For large-scale networks, we use this filter to normalize the error
% Error_Normalizer = [ones(N,1);count];
% Error_Normalizer(Error_Normalizer<1) = 1;
% For large-scale networks, we use this filter to normalize the error
% Error_Normalizer = [ones(N,1);ones(N,1)];
% MAX_ERROR = 0.02;
MAX_ERROR = 10^(-9);

%%% Count the number of complete constraints

fprintf('Solving the system...\n');

x = rand(2*N,1)-1/2;
error = inf;

temp_count = ones(size(count));
Error_Normalizer = [ones(N,1);temp_count];
Error_Normalizer(Error_Normalizer<1) = 1;

lambda = x(1:N);
theta = x(N+1:2*N);
[J,P_M,O,D] = my_count_derivative_new(lambda,theta,temp_count,A);

ValueF = [sum(P_M')'-1+D; (sum(temp_count .* P_M)'+(O-1).*temp_count)];
error = [error,max(abs(ValueF)./Error_Normalizer)];
if(isnan(error(end)))
    count_modified = max(abs(count-temp_count));
    return;
end

step = 1;


while(abs(error(end))>MAX_ERROR)

    % x = x - 0.3*pinv(J)*ValueF;
    x = x - 0.3*lsqminnorm(J,ValueF);

    lambda = x(1:N);
    theta = x(N+1:2*N);

    [J,P_M,O,D] = my_count_derivative_new(lambda,theta,temp_count,A);
    
    ValueF = [sum(P_M')'-1+D; (sum(temp_count .* P_M)'+(O-1).*temp_count)];
    error = [error,max(abs(ValueF)./Error_Normalizer)];
    step = step + 1;

    if(isnan(error(end)))
        break;
    end

    if(step > MAX_LITERATURE_STEP)
        break;
    end

end
fprintf('Solution for stage 1 was found\n')

error = inf;

temp_count = temp_count*mean(count);
x(N+1:2*N) = x(N+1:2*N)/mean(count);

lambda = x(1:N);
theta = x(N+1:2*N);

Error_Normalizer = [ones(N,1);temp_count];
Error_Normalizer(Error_Normalizer<1) = 1;

[J,P_M,O,D] = my_count_derivative_new(lambda,theta,temp_count,A);
ValueF = [sum(P_M')'-1+D; (sum(temp_count .* P_M)'+(O-1).*temp_count)]./Error_Normalizer;
step = 1;
error = sum(abs(ValueF));

while(abs(error(end))>MAX_ERROR)

    % x = x - 0.2*pinv(J)*ValueF;
    x = x - 0.2*lsqminnorm(J,ValueF);

    lambda = x(1:N);
    theta = x(N+1:2*N);

    [J,P_M,O,D] = my_count_derivative_new(lambda,theta,temp_count,A);

    ValueF = [sum(P_M')'-1+D; (sum(temp_count .* P_M)'+(O-1).*temp_count)];

    error = [error,max(abs(ValueF)./Error_Normalizer)];
    step = step + 1;

    if(isnan(error(end)))
        break;
    end
    if(step > MAX_LITERATURE_STEP)
        break;
    end

end
fprintf('Solution for stage 2 was found\n')

OVERALL_STEP = 1;
damp_factor = 0.1;

while((max(abs(count-temp_count))>10^(-1)) && (OVERALL_STEP<MAX_STEP))

    factor = 1.01;
    flag = 0;
    x_original = x;

    while (flag == 0)

        x = x_original;
        factor = factor-0.01;

        next_temp_count = temp_count + (count-temp_count) * factor;
        error = inf;

        temp = next_temp_count;
        temp(temp<100) = 100;
        Error_Normalizer = [ones(N,1);temp];

        step = 1;
        lambda = x(1:N);
        theta = x(N+1:2*N);

        [J,P_M,O,D] = my_count_derivative_new(lambda,theta,next_temp_count,A);
        ValueF = [sum(P_M')'-1+D; (sum(next_temp_count .* P_M)'+(O-1).*next_temp_count)];
        error = [error,max(abs(ValueF)./Error_Normalizer)];

        if(isnan(error(end)))
            break;
        end

        while(abs(error(end))>MAX_ERROR)

            step = step + 1;

            % x0 = x - 0.05*pinv(J)*ValueF;
            x0 = x - damp_factor*lsqminnorm(J,ValueF);
            OVERALL_STEP = OVERALL_STEP + 1;

            lambda = x0(1:N);
            theta = x0(N+1:2*N);

            [J,P_M,O,D] = my_count_derivative_new(lambda,theta,next_temp_count,A);
            ValueF = [sum(P_M')'-1+D; (sum(next_temp_count .* P_M)'+(O-1).*next_temp_count)];

            error = [error,max(abs(ValueF)./Error_Normalizer)];

            x = x0;

            fprintf('Now the Factor is %f, Error is %f, step is %d\n',factor,error(end),step);

            if(abs(error(end)) == inf)
                break;
            end
            if(isnan(abs(error(end))))
                break;
            end
            if(step>MAX_LITERATURE_STEP)
                break;
            end
            if ((abs(error(end))<1)&& (abs(error(end))>=0.02))
                damp_factor = 0.07;
            elseif (abs(error(end))<0.02)
                damp_factor = 0.05;
            end
        end

        if (abs(error(end))<MAX_ERROR)
            flag = 1;
            flag_global = 1;
            MAX_LITERATURE_STEP = 50;
            temp_count = next_temp_count;
        end

        if OVERALL_STEP>MAX_STEP
            count_modified = temp_count;
            error = sum(abs([sum(P_M')'-1+D; (sum(count .* P_M)'+(O-1).*count)]./Error_Normalizer));
            return;
        end
    end
end

[J,P_M,O,D] = my_count_derivative_new(lambda,theta,count,A);
error = max(abs([sum(P_M')'-1+D; (sum(count .* P_M)'+(O-1).*count)]./Error_Normalizer));
count_modified = temp_count';
