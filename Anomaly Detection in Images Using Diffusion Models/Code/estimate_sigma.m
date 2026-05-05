
function sigma = estimate_sigma(embedding, M)
    N = size(embedding,1);
    pairs = randi(N, [M, 2]);
    dists = zeros(M,1);
    for i = 1:M
        diff = embedding(pairs(i,1), :) - embedding(pairs(i,2), :);
        dists(i) = norm(diff)^2;
    end
    sigma = sqrt(var(dists));
end
