function [H, best_inliers] = estimate_H_robust(K,x1,x2, pixel_threshold)
x_norm1 = pflat(inv(K) * x1);
x_norm2 = pflat(inv(K) * x2);


err_threshold = 3 * pixel_threshold / K(1,1);
s = 4;
N = length(x1);
eps = 0.1;
alpha = 0.98;
best_inliers_num = 0;

% iter = 1000;
i = 1;
T = log(1-alpha)/log(1-eps^s);
total_in = 0;
while i<100
    randind = randi(N, 1, s);
    H = estimate_homography_DLT(x_norm1(: , randind), x_norm2(:, randind));
%     mean(compute_homography_errors(H, x_norm1, x_norm2).^2)
%     mean(compute_homography_errors(H', x_norm2, x_norm1).^2)
    inliers = (compute_homography_errors(H, x_norm1, x_norm2).^2 ...
       + compute_homography_errors(inv(H), x_norm2, x_norm1).^2)/2< err_threshold^2;
    if sum(inliers) > best_inliers_num
        best_inliers_num = sum(inliers);
        best_inliers = inliers;
        best_H = H;
    end
   
    eps = max(0.1,best_inliers_num/N);
    T = min(T, log(1-alpha)/log(1-eps^s));
    i = i + 1;
end
disp("Number of inliers:")
disp(best_inliers_num)
disp("Number of iterations:")
disp(i)
H = best_H;
end

