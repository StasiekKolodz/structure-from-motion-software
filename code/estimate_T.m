function P = estimate_T(R_abs, x, X)
    num_points = size(X, 2);
    M = zeros(3*num_points, num_points + 4);
    for i = 1:num_points
        M((3*i-2), 1) = 1;
        M((3*i-1), 2) =1;
        M((3*i), 3) = 1;
        M((3*i-2):(3*i), 4) = (X(1:3,i)'*R_abs')';
        M((3*i-2):(3*i), 4+i) = -x(:,i);
    end
    [~,S,V] = svd(M);
    eigen_vec_min = V(:, end);
    StS = S' * S;
    eigen_val_min = StS(end, end);
%     P = [eigen_vec_min(1:4)';
%          eigen_vec_min(5:8)';
%          eigen_vec_min(9:12)'];
%     T = eigen_vec_min(1:3);
    T = eigen_vec_min(1:3)/eigen_vec_min(4);
    P = [R_abs T];
end