function plot_points_2D(points, t, m_size)
%(2, n)-array representing n two dimensional points in Cartesian coordinates
if nargin == 2
 m_size = 20;
end

plot(points(1, :), points(2, :), '.', 'MarkerSize',m_size)
title(t)
end