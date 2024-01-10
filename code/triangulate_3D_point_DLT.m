function X = triangulate_3D_point_DLT(P1, P2, x1, x2)
    X = zeros(4, length(x1));
    for i = 1:length(x1)
        M = zeros([6 6]);
        M(1:3, 1:4) = P1;
        M(4:6, 1:4) = P2;
        M(1:3, 5) = -x1(:, i);
        M(4:6, 6) = -x2(:, i);
    
        [~,S,V] = svd(M);
        eigen_vec_min = V(:, end);
        Xi = eigen_vec_min(1:4);
        X(:, i) = Xi;
    end
end