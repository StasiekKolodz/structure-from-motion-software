function [R_rel, best_inliers] = find_R_relative(K, x1, x2, pixel_threshold)
    [E, ~, best_inliers] = paralel_ransac(K, x1, x2, pixel_threshold);
%     [E, best_inliers] = estimate_E_robust(K,x1,x2, pixel_threshold);
    x1_in = x1(:, best_inliers);
    x2_in = x2(:, best_inliers);
    
    x1_n = pflat(inv(K)*x1_in);
    x2_n = pflat(inv(K)*x2_in);

    P = extract_P_from_E(E);
    % P1 = [eye(3), zeros(3,1)];
    P2 = find_best_P(P, x1_n, x2_n);
    R_rel = P2(1:3,1:3);
end