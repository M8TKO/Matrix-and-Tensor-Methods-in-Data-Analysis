
function score = anomaly_score(embedding, locs, window_size, mask_size, sigma)
    N = size(embedding, 1);
    score = zeros(N, 1);
    for i = 1:N
        center = locs(i, :);
        dist_sum = 0;
        count = 0;
        for j = 1:N
            if i == j, continue; end
            d_rc = abs(locs(j,1) - center(1)) + abs(locs(j,2) - center(2));
            if d_rc <= window_size && d_rc > mask_size
                diff = embedding(i,:) - embedding(j,:);
                dist = sum(diff.^2);
                dist_sum = dist_sum + exp(-dist / (sigma^2 + eps));
                count = count + 1;
            end
        end
        if count > 0
            score(i) = 1 - (dist_sum / count);
        else
            score(i) = 0;
        end
    end
end
