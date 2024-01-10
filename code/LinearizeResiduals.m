function [r,J] = LinearizeResiduals(P,X,x)
    P_1 = P(1, :);
    P_2 = P(2, :);
    P_3 = P(3, :);
    T = P(:,4);
    N = size(X, 2);
    r = zeros(N*2, 1);
    J = zeros(N*2,3);
    for j = 1:N
        X_j = X(:, j);
        x_j = x(:, j);

        [~, res] = ComputeResidualVector(P,X_j, x_j);
        r(2*j-1:2*j, 1) =  reshape(res', [2 1]);
        
        J(2*j-1:2*j, :) = [-1/T(3) 0 T(1)/(T(3)^2);
                     0 -1/T(3) T(2)/(T(3)^2)];
    end
  
end