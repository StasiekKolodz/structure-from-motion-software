function [P, best_inliers] = estimate_T_robust(K, R_abs, x, X, inlier_threshold)
%     x_norm1 = pflat(inv(K) * x1);
%     x_norm2 = pflat(inv(K) * x2);
    
    err_threshold = 3 * inlier_threshold / K(1,1);
    s = 2;
    N = size(X, 2);
    eps = 0.01;
    alpha = 0.98;
    best_inliers_num = 0;
    
    i = 1;
    T = log(1-alpha)/log(1-eps^s);
    total_in = 0;
    while i<T
        randind = randi(N, 1, s);
        P = estimate_T(R_abs, x(: , randind), X(:, randind));
        inliers = compute_P_errors(P, x, X) < err_threshold;
        if sum(inliers) > best_inliers_num
            best_inliers_num = sum(inliers);
            best_inliers = inliers;
            best_P = P;
        end
       
        eps = max(0.01,best_inliers_num/N);
        T = min(T, log(1-alpha)/log(1-eps^s));
        i = i + 1;
    end
    disp("Number of inliers:")
    disp(best_inliers_num)
    disp("Number of iterations:")
    disp(i)
    P = best_P;
end