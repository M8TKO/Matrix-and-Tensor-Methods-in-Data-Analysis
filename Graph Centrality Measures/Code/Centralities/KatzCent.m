function centers = KatzCent(A, alpha)
    [~, eigen_value] = eigs(A, 1, 'largestreal');
    [eigen_vectors, ~] = sort(diag(eigen_value), 'descend');

    if (alpha <= 0 || alpha >= (1 / eigen_vectors(1)))
        disp("Faktor nije dobar, nema konvergencije...");
        centers = [];
        return;
    end

    n = size(A, 1);
    k = (eye(n) - alpha * A) \ ones(n, 1);
    [~, centers] = sort(k, 'descend');
end
