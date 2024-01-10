function plot_reconstructions(X, m_size)
    N = length(X);
    cm = turbo(N);
    hold on
    for i =1:N
        points = X{i};
        plot3(points(1 ,:) ,points(2 ,:) , points(3 ,:), ' . ', 'MarkerEdgeColor', cm(i, :), 'MarkerSize', m_size)
    end
end