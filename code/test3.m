% rel = R2*R1';
% rel/rel(3,3)
% for i = 1:4
%     temp = RT{i};
%     temp./temp(3,3)
% end

p = P{2};
p = p/p(3,3)
r = R_abs{2};
r = r/r(3,3)

p(1:3,1:3)-r