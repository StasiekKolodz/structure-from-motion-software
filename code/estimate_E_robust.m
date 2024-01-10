function [E, best_inliers] = estimate_E_robust(K,x1,x2, pixel_threshold)
x_norm1 = pflat(inv(K) * x1);
x_norm2 = pflat(inv(K) * x2);

err_threshold = pixel_threshold / K(1,1);
s = 8;
N = length(x1);
eps = 0.1;
alpha = 0.98;
best_inliers_num = 0;

% iter = 1000;
i = 1;
T = log(1-alpha)/log(1-eps^s);
total_in = 0;
while i<T
    randind = randi(N, 1, s);
    [E, ~] = estimate_E_DLT(x_norm1(: , randind), x_norm2(:, randind));
    E = enforce_essential(E);
    inliers = (compute_epipolar_errors(E, x_norm1, x_norm2 ).^2 + ...
        compute_epipolar_errors(E', x_norm2 ,x_norm1).^2) / 2 < err_threshold ^2;
    if sum(inliers) > best_inliers_num
        best_inliers_num = sum(inliers);
        best_inliers = inliers;
        best_E = E;
    end
   
    eps = max(0.1,best_inliers_num/N);
    T = min(T, log(1-alpha)/log(1-eps^s));
    i = i + 1;
end
disp("Number of inliers:")
disp(best_inliers_num)
disp("Number of iterations:")
disp(i)
E = best_E;
end

