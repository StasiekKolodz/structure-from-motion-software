function total_error = ComputeTotalReprojectionError(P, X, x)
    total_error = 0;
    for j = 1:size(X, 2)
        X_j = X(:, j);
        x_j = x(:,j);
        [err,~] = ComputeResidualVector(P,X_j,x_j);
        total_error = total_error + err;
    end
end
