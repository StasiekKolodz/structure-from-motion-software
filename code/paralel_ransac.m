function [E, H, best_inliers_E] = paralel_ransac(K,x1,x2, pixel_threshold)
x_norm1 = pflat(inv(K) * x1);
x_norm2 = pflat(inv(K) * x2);

err_threshold_E = pixel_threshold / K(1,1);
err_threshold_H = 3 * pixel_threshold / K(1,1);

s_E = 8;
s_H = 4;
N = length(x1);
eps_E = 0.1;
eps_H = 0.1;
alpha = 0.98;
best_inliers_num_E = 0;
best_inliers_num_H = 0;

run_ransac = 1;
iter = 0;

T_E = log(1-alpha)/log(1-eps_E^s_E);
T_H = log(1-alpha)/log(1-eps_H^s_H);

total_in = 0;
best_source = "";
while run_ransac
    iter = iter+1;
    %Find E
    randind = randi(N, 1, s_E);
    [E, is_valid] = estimate_E_DLT(x_norm1(: , randind), x_norm2(:, randind));
    E = enforce_essential(E);

    inliers_E = (compute_epipolar_errors(E, x_norm1, x_norm2 ).^2 + ...
        compute_epipolar_errors(E', x_norm2 ,x_norm1).^2) / 2 < err_threshold_E ^2;

    if sum(inliers_E) > best_inliers_num_E && is_valid
        best_inliers_num_E = sum(inliers_E);
        best_inliers_E = inliers_E;
        best_E = E;
        best_source = "E";
        eps_E = max(0.1,best_inliers_num_E/N);
        T_E = min(T_E, log(1-alpha)/log(1-eps_E^s_E));

        
    end
   
    
%     Find H
    randind = randi(N, 1, s_H);
    H = estimate_homography_DLT(x_norm1(: , randind), x_norm2(:, randind));

    inliers_H = (compute_homography_errors(H, x_norm1, x_norm2).^2 ...
       + compute_homography_errors(inv(H), x_norm2, x_norm1).^2)/2< err_threshold_H^2;

    %If H is new best homography
    if sum(inliers_H) > best_inliers_num_H
%         Adjust best H, eps_h and iterations
        best_inliers_num_H = sum(inliers_H);
        best_inliers_H = inliers_H;
        best_H = H;
        eps_H = max(0.1,best_inliers_num_H/N);
        T_H = min(T_H, log(1-alpha)/log(1-eps_H^s_H));
%       Extract two solutions
        [R1, t1, R2, t2] = homography_to_RT(H, x_norm1(: , randind), x_norm2(: , randind));
%         Create new E's from H
        T_skew1 = [0 -t1(3) t1(2);
                  t1(3) 0 -t1(1);
                  -t1(2) t1(1) 0];
        T_skew2 = [0 -t2(3) t2(2);
                  t2(3) 0 -t2(1);
                  -t2(2) t2(1) 0];
        E_from_H{1} = enforce_essential(T_skew1 * R1);
        E_from_H{2} = enforce_essential(T_skew2 * R2);
%     Test new E
        for i = 1:2
%           Find inliners
            inliers_E_from_H{i} = (compute_epipolar_errors(E_from_H{i}, x_norm1, x_norm2 ).^2 + ...
                compute_epipolar_errors(E_from_H{i}', x_norm2 ,x_norm1).^2) / 2 < err_threshold_E ^2;
%           IF E is new best E
            if sum(inliers_E_from_H{i}) > best_inliers_num_E
                [is_valid, best_inliers_EH] = check_E_acceptable(E, ...
                    x_norm1(:,inliers_E_from_H{i}) , x_norm2(:,inliers_E_from_H{i}));
%              
                if is_valid
                    %Filter out inliers not in front of camera
                    in_to_filter = inliers_E_from_H{i};
                    for j = 1:size(in_to_filter,2)
                        c=0;
                        if in_to_filter(i) == 1
                            c = c+1;
                            in_to_filter(i) = best_inliers_EH(c);
                        end
                    end
                    inliers_E_from_H{i} = in_to_filter;

    %               If E is accetable and still the best assign it to the best solution
                    if sum(in_to_filter) > best_inliers_num_E
                        best_E = E_from_H{i};
                        best_inliers_num_E = sum(inliers_E_from_H{i});
                        best_inliers_E = inliers_E_from_H{i};
                        best_source = "H";
                        eps_E = max(0.1,best_inliers_num_E/N);
                        T_E = min(T_E, log(1-alpha)/log(1-eps_E^s_E));
                    end
                end
            end
        end
    end
   
%    Finish after sufficient iterations for a good E or H
    if T_E < iter && T_H < iter
        run_ransac = 0;
    end
   
end

disp("Paralel ransac finished")
disp("Number of iterations:")
disp(iter)
disp("Number of inliers:")
disp(best_inliers_num_E)
disp("Best source:")
disp(best_source)
E = best_E;
H = best_H;
end

