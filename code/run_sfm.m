function [X_all, P_ref_cameras] = run_sfm(dataset)

[K, img_names, init_pair, pixel_threshold] = get_dataset_info(dataset);
dataset_size = length(img_names);
images = read_images(img_names, dataset);
vl_setup

%Find matches and descriptors
if isfile("SIFT_data_dataset_"+num2str(dataset)+".mat")
    %Load data
    disp("Datafile exist:)")
    load("SIFT_data_dataset_"+num2str(dataset)+".mat")
else
    %Compute and save data
    disp("Computing and saving data for dataset: " + num2str(dataset))
    for i = 1:dataset_size-1
        [fA, dA, fB, dB, matches, xA, xB] = find_SIFT(images{i}, images{i+1});
        descriptors{i} = dA;
        correspondences{i} = [xA; xB];
        features{i} = fA;
    end
    %Add descriptor and features of last image
    descriptors{dataset_size} = dB;
    features{dataset_size} = fB;
    save("SIFT_data_dataset_"+num2str(dataset), "descriptors", "correspondences", "features")
end


% Find relative and obsolute rotations 
R_abs{1} = eye(3);
for i = 1:dataset_size-1
    xA = correspondences{i}(1:2,:);
    xB = correspondences{i}(3:4,:);
    x1 = [xA; ones(1, length(xA))];
    x2 = [xB; ones(1, length(xB))];
    [R_rel, inliers] = find_R_relative(K, x1, x2, pixel_threshold);
    relative_inliers{i} = inliers;
    R_abs{i+1} = R_rel*R_abs{i};
end


% Reconstruct initial 3D points
[fA, dA, fB, dB, matches, xA, xB] = find_SIFT(images{init_pair(1)}, images{init_pair(2)});
desc_X = dA(:, matches(1,:));
x1 = [xA; ones(1, length(xA))];
x2 = [xB; ones(1, length(xB))];
[P2_rel, X, inliers] = reconstruct_3D(K, x1, x2, pixel_threshold);
desc_X = desc_X(:, inliers);
X = R_abs{init_pair(1)}' * X(1:3,:);

%Find T
for i = 1:dataset_size
    [matches_2d_3d, scores] = vl_ubcmatch(descriptors{i}, desc_X);
    x_match = features{i}(1:2, matches_2d_3d(1,:));
    x_match = [x_match; ones(1, length(x_match))];
    x_match_n = pflat(inv(K) * x_match);
    X_match = X(:, matches_2d_3d(2,:));
    X_match = [X_match; ones(1, length(X_match))];
    [P, inliers] = estimate_T_robust(K, R_abs{i}, x_match_n, X_match, pixel_threshold);
    P_cameras{i} = P;
    T_inliers{i} = inliers;
    P_ref = refine_T_LM(P, X_match(:, inliers), x_match_n(:, inliers));
    P_ref_cameras{i} = P_ref;
%     er1 = ComputeTotalReprojectionError(P, X_match(:, inliers), x_match_n(:, inliers));
%     er2 = ComputeTotalReprojectionError(P_ref, X_match(:, inliers), x_match_n(:, inliers));
%     er1
%     er2
end

%Triangulate points for all pairs
% X_all = X_match;
for i = 1:dataset_size-1
    xA = correspondences{i}(1:2,:);
    xB = correspondences{i}(3:4,:);
    x1_n = pflat(inv(K)*[xA; ones(1, length(xA))]);
    x2_n = pflat(inv(K)*[xB; ones(1, length(xB))]);
    x1_in = x1_n(:, relative_inliers{i});
    x2_in = x2_n(:, relative_inliers{i});
    X = pflat(triangulate_3D_point_DLT(P_ref_cameras{i}, P_ref_cameras{i+1}, x1_in, x2_in));
    X_filtered = filter_center_of_gravity(X, 0.9);
    X_all{i} = X_filtered;
%     figure(i)
%     hold on
%     plot_points_3D(filter_center_of_gravity(X, 0.9), "")
%     plotcams({P_ref_cameras{i}, P_ref_cameras{i+1}})
end

t = toc;
disp("time:")
disp(t)

% save("reconstruction_dataset_"+num2str(dataset), "X_all", "P_ref_cameras")

figure(1)
hold on
plot_reconstructions(X_all, 1.5);
plotcams(P_ref_cameras)
end