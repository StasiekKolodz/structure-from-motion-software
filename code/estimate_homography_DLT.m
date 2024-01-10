function H = estimate_homography_DLT(x1, x2)

    num_points = length(x1);
    M = zeros(9, 2*num_points);

    M((1:3), 1:num_points) = -x1;
    M((4:6), num_points+1:2*num_points) = -x1;
%         M((2*i), 1:3) = x1(:,i)';
    for i = 1:num_points
        M(7:9, i) = [x2(1, i).*x1(1, i); x2(1, i).*x1(2, i); x2(1, i)];
        M(7:9, num_points+i) = [x2(2, i).*x1(1, i); x2(2, i).*x1(2, i); x2(2, i)];
    end

    [U,S,V] = svd(M);
    H = (reshape(U(:,9), 3, 3)).';
% 
%     eigen_vec_min = V(:, end);
%     StS = S' * S;
%     eigen_val_min = StS(end, end);
   
% %     x2_h = H*x1;
%     for i = 1:4
%         distance(i) = point_to_point_2D_distance(x2_h(:,i), x2(:,i))
%     end
%     mean(distance)
end