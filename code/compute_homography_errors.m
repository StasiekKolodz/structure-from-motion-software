function distances = compute_homography_errors(H, x1, x2)
    distances = zeros(length(x2), 1);
    x1 = pflat(x1);
    x2 = pflat(x2);

    x2_h = pflat(H*x1);
%     figure(1)
%     hold on
%     plot_points_2D(x2, "")
%     plot_points_2D(x2_h, "")
    for i = 1:length(x2)
        distances(i) = point_to_point_2D_distance(x2(:, i), x2_h(:,i));
    end
end