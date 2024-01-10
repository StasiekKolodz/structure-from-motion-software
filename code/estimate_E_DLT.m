function [E, is_valid] = estimate_E_DLT(x1s, x2s)  
    M = zeros(length(x1s), 9);
    is_valid = 1;
    for i = 1:length(x1s)
        M(i, :) = reshape((x2s(:,i)*x1s(:,i)')', 1, []);
    end
    [~,S,V] = svd(M);
    eigen_vec_min = V(:, end);
    StS = S' * S;
    E = reshape(eigen_vec_min, 3, 3)';
    eigen_val_min = StS(end, end);
    
    temp = StS(end-1, end-1)/StS(1,1);
    if temp < 10^(-15)
        is_valid = 0;
    end

    if StS(end-1, end-1) > 10^(-4)
        is_valid = 0;
    end

end