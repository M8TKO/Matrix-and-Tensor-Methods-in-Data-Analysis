function centers = EigenValueCent(A, directed, direction)
    if directed && strcmp(direction, 'in')
        A = A';
    end
    [eigen_vectors, ~] = eigs(A, 1, 'largestreal');
    importance_scores = abs(eigen_vectors);
    [~, centers] = sort(importance_scores, 'descend');
end
