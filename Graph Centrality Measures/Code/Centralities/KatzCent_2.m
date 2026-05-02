function centers = KatzCent_2(A, alpha)
    [~, eigen_value] = eigs(A, 1, 'largestreal');
    [eigen_vectors, ~] = sort(diag(eigen_value), 'descend');

    if (alpha <= 0 || alpha >= (1 / eigen_vectors(1)))
        disp("Faktor nije dobar, nema konvergencije...");
        centers = [];
        return;
    end

    n = size(A, 1);  
    k = ones(n, 1); 
    x = ones(n, 1);
    for i=1:1000
        k=alpha*A*k+x;
    end
    [~, centers] = sort(k, 'descend');
end
