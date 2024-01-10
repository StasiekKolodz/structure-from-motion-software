function [err,res] = ComputeResidualVector(P,X_j,x_j)
%     res = zeros(1, 2);
    P_1 = P(1, :);
    P_2 = P(2, :);
    P_3 = P(3, :);


    res = [x_j(1)-(P_1*X_j)/(P_3*X_j) x_j(2)-(P_2*X_j)/(P_3*X_j)];
    err = norm(res)^2;

end