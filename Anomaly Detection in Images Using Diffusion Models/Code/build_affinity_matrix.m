
function W = build_affinity_matrix(X, k)
    N = size(X, 1);
    D = pdist2(X, X, 'euclidean');
    [~, idx] = sort(D, 2);
    sigma = D(sub2ind([N, N], (1:N)', idx(:, k)));
    W = zeros(N, N);
    for i = 1:N
        for j = idx(i, 2:k)
            W(i, j) = exp(- (D(i,j)^2) / (sigma(i)*sigma(j) + eps));
        end
    end
    W = max(W, W');
end
