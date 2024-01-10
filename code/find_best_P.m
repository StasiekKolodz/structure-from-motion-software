function best_P = find_best_P(P, x1, x2)
    P1 = [eye(3), zeros(3,1)];
    best_idx = -1;
    best_score = -inf;
    
    for i =1:4
        X = pflat(triangulate_3D_point_DLT(P1, P{i}, x1, x2));
        proj2 = P{i}*X;
        score = sum(all([X(3, :)>0; proj2(3, :)>0], 1));
%         disp(score)
        if score > best_score
            best_idx = i;
            best_score = score;
        end
    end
   best_P = P{best_idx};
end