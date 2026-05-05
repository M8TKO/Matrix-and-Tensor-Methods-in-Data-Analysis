
function [embedding, lambda] = diffusion_map(W, m)
    d = sum(W, 2);
    D_inv = spdiags(1./sqrt(d), 0, length(d), length(d));
    P = D_inv * W;
    [psi, lambda] = eigs(P, m+1, 'largestreal');
    [lambda_vals, idx] = sort(diag(lambda), 'descend');
    psi = psi(:, idx);
    embedding = psi(:, 2:end) .* lambda_vals(2:end)';
    lambda = lambda_vals(2:end);
end
