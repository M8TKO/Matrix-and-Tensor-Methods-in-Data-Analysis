function centers = ResSubgraphCent(A, alpha)
    [~, eigen_values] = eigs(A, 1, 'largestreal');
    eigen_values = sort(diag(eigen_values), 'descend');

    if (alpha <= 0 || alpha >= (1 / eigen_values(1)))
        disp("Faktor nije dobar, nema konvergencije...");
        centers = [];
        return;
    end
    
    n = size(A,1);
    B = diag(inv(eye(n,n)-alpha*A));
    [~,centers] = sort(B,'descend');
end
