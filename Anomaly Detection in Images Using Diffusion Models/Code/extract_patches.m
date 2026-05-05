
function [X, locations] = extract_patches(I, patch_size)
    [h, w] = size(I);
    half_p = floor(patch_size / 2);
    I_pad = padarray(I, [half_p half_p], 'symmetric');

    % Preallocate output matrices
    num_patches = h * w;
    patch_dim = patch_size ^ 2;

    X = zeros(num_patches, patch_dim);       % Each row is a patch
    locations = zeros(num_patches, 2);       % (row, col) for each patch

    idx = 1;
    for i = 1:h
        for j = 1:w
            patch = I_pad(i:i+2*half_p, j:j+2*half_p);
            X(idx, :) = patch(:)';
            locations(idx, :) = [i, j];
            idx = idx + 1;
        end
    end
end