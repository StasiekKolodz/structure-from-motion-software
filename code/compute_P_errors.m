function distances = compute_P_errors(P, x, X)
    distances = zeros(size(X, 2), 1);
    x = pflat(x);
%     X = pflat(X);

    proj = pflat(P*X);
    for i = 1:size(X, 2)
        distances(i) = point_to_point_2D_distance(x(:, i), proj(:,i));
    end
end