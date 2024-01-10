function P = estimate_camera_DLT(x, X)
    num_points = length(X);
    M = zeros(3*num_points, num_points + 3);

    for i = 1:length(X)
        M((3*i-2), 1:4) = X(:,i)';
        M((3*i-1), 5:8) = X(:,i)';
        M((3*i), 9:12) = X(:,i)';
        M((3*i-2):(3*i), 12+i) = -x(:,i);
    end
    [~,S,V] = svd(M);
    eigen_vec_min = V(:, end);
    StS = S' * S;
    eigen_val_min = StS(end, end);
    P = [eigen_vec_min(1:4)';
         eigen_vec_min(5:8)';
         eigen_vec_min(9:12)'];
end