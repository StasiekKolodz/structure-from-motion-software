function distances = compute_epipolar_errors(F, x1s, x2s)
    distances = zeros(length(x2s), 1);
    l = F*x1s;
    for i = 1:length(x2s)
        distances(i) = point_line_distance_2D(x2s(:, i), l(:,i));
    end
end