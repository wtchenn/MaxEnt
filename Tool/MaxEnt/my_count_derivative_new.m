
function [J,M,O,D] = my_count_derivative_new(lambda,theta,count,A)

N =size(A,1);

if size(lambda,2)~=1
    lambda = lambda';
end

if size(theta,2)~=1
    theta = theta';
end

if size(count,2)~=1
    count = count';
end

O = my_D(theta.* count);
D = my_D(lambda);
J = sparse(2*N,2*N);
M = zeros(N,N);

for i = 1:N 
    temp_next_neighbor = find(A(i,:)==1);
    temp_front = find(A(:,i)==1)';

    % Update J
    J(i,i) = J(i,i) + my_D_diff(lambda(i)) + sum(my_D_diff(lambda(i)+theta(temp_next_neighbor)*count(i)));
    J(i+N,i+N) = J(i+N,i+N) + (count(i).^2*my_D_diff(theta(i)*count(i)) + sum(count(temp_front).^2.*my_D_diff(lambda(temp_front)+theta(i)*count(temp_front))));
    for j = temp_next_neighbor
        % Update M
        M(i,j) = my_D(lambda(i)+theta(j)*count(i));

        % Update J
        J(i,j+N) = count(i) * my_D_diff(lambda(i)+theta(j) * count(i));
    end
    for j = temp_front
        J(i+N,j) = my_D_diff(lambda(j)+theta(i)*count(j)) * count(j);
    end
end





