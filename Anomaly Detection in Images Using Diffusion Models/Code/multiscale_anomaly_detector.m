
function score_full = multiscale_anomaly_detector(I, L, patch_sizes, window_sizes, mask_half, sample_percents)
    pyramid = gaussian_pyramid(I, L, 1);
    suspicious_pixels = [];
    for level = L:-1:0
        fprintf("Level %d\n", level);
        I_level = pyramid{level+1};
        [h, w] = size(I_level);
        N_total = h * w;
        [X, locs] = extract_patches(I_level, patch_sizes(level+1));
        if level == L
            N_sample = round(sample_percents(level+1) * N_total);  % NEW
            all_indices = randperm(N_total, N_sample);
        else
            idx_from_suspicious = sub2ind([h, w], suspicious_pixels(:,1), suspicious_pixels(:,2));
            n_suspicious = size(idx_from_suspicious, 1);
            n_random = max(round(sample_percents(level+1) * N_total) - n_suspicious, 0);
            all_indices = unique([idx_from_suspicious; randperm(N_total, n_random)']);
        end
        sampled_X = X(all_indices, :);
        %sampled_locs = locs(all_indices, :);
        W = build_affinity_matrix(sampled_X, 16);
        [embedding, lambda] = diffusion_map(W, 5);
        sigma = estimate_sigma(embedding, 1000);
        full_embedding = nystrom_extension(X, sampled_X, embedding, lambda, 16);
        size(full_embedding)
        score = anomaly_score(full_embedding, locs, window_sizes(level+1), mask_half, sigma);
        if level == 0
            score_full = zeros(h, w);
            for i = 1:length(score)
                r = locs(i,1);
                c = locs(i,2);
                score_full(r,c) = score(i);
            end
        end
        thresh = prctile(score, 95);
        suspicious_pixels = locs(score >= thresh, :);
    end
end
