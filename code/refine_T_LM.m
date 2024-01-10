function P_refined = refine_T_LM(P, X, x)
    iter_number = 200;
%     P_refined = zeros(size(X));
%     T_refined = zeros(3,1);
    T = P(:,4);
    mu = 1;
%         X_j = X(:, j);
%         x_j = x(:, j);
    for iter = 1:iter_number    
        err = ComputeTotalReprojectionError(P, X, x);
        [r,J] = LinearizeResiduals(P, X, x);
        delta_T = ComputeUpdate(r, J, mu);  
        T_refined = T + delta_T;
        P_refined = [P(:, 1:3) T_refined];
        err_ref =  ComputeTotalReprojectionError(P_refined, X, x);
        if err_ref - err < 0
            T = T_refined;
            P(:, 4) = T_refined;
            mu = mu/10;
        else
            mu = mu * 10;
        end
    end
    P_refined = P;
end