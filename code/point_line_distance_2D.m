function dist = point_line_distance_2D(point, line)
a = line(1);
b = line(2);
c = line(3);
dist = abs(a*point(1) + b*point(2) + c)/sqrt(a^2 + b^2);
end