function extended = nystrom_extension(X_all, X_sample, embedding_sample, lambda, k)
    % Inputs:
    % - X_all: all patches
    % - X_sample: sampled patches
    % - embedding_sample: eigenvectors (rows correspond to X_sample)
    % - lambda: eigenvalues
    % - k: # neighbors for local affinity

    N = size(X_all, 1);
    M = size(X_sample, 1);
    d = size(embedding_sample, 2);
    extended = zeros(N, d);

    % Build distance matrix between all and sample
    D = pdist2(X_all, X_sample, 'euclidean');
    [~, idx] = sort(D, 2);
    sigma_i = D(:,k);
    sigma_j = D(sub2ind([N, M], (1:N)', idx(:,k)));

    % Compute weight matrix W between X_all and X_sample
    W = zeros(N, M);
    for i = 1:N
        for j = 1:k
            col = idx(i,j);
            dist2 = D(i,col)^2;
            W(i, col) = exp(-dist2 / (sigma_i(i)*sigma_j(i) + eps));
        end
    end

    % Normalize rows (row-stochastic)
    W = W ./ (sum(W, 2) + eps);

    % Nyström extension
    for dim = 1:d
        extended(:,dim) = (W * embedding_sample(:,dim)) / lambda(dim);
    end
end
