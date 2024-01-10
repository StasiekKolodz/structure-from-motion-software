function delta_X_j = ComputeUpdate(r, J, mu)
    C = J.'*J + mu * eye( size (J ,2));
    c = J.'*r ;
    delta_X_j = -C \ c ;
end