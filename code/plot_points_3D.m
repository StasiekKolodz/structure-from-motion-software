function plot_points_3D(points, t, m_size)
%(3, n)-array representing n 3 dimensional points in Cartesian coordinates
if nargin == 2
 m_size = 5;
end

plot3(points(1 ,:) ,points(2 ,:) , points(3 ,:), ' . ', 'MarkerEdgeColor', 'green', 'MarkerSize', m_size)
title(t)
end