function X_filtered = filter_center_of_gravity(X, p)
    m = mean(X, 2);
    dist = zeros(size(X, 2), 1);
    for i = 1:size(X, 2)
        dist(i) = norm(X(:,i)-m);
    end
    
    q = quantile(dist, p);
    filter = dist<5*q;
    X_filtered = X(:, filter);
end