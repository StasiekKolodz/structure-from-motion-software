function [is_valid, best_inliers] = check_E_acceptable(E, x1, x2)
    P2 = extract_P_from_E(E);
    P1 = [eye(3), zeros(3,1)];
    scores = zeros(4,1);
    best_score = 0;
    for i =1:4
        X = pflat(triangulate_3D_point_DLT(P1, P2{i}, x1, x2));
        proj2 = P2{i}*X;
        inliers = all([X(3, :)>0; proj2(3, :)>0], 1);
        score = sum(inliers);
        if score > best_score
            best_score = score;
            best_inliers = inliers;
        end
%         disp(score)
        scores(i) = score;
    end
     
%    Verify if "acceptable" if exactly one of the 4 cheirality configurations has "all" inliers 
    scores = sort(scores);
    if scores(end) > 0.9 * size(x1,2) && scores(end-1)< 0.9* size(x1, 2)
        is_valid = 1;
    else
        is_valid = 0;
    end
end