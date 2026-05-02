function centers = ClosenessCent(A, directed)
    n = size(A, 1);
    closeness = zeros(n, 1);
    
    for i = 1:n
        if directed
            D = distances(digraph(A), i);
        else
            D = distances(graph(A), i);
        end

        D(isinf(D)) = n;
        closeness(i) = (n-1) / sum(D);
    end

    [~, centers] = sort(closeness, 'descend');
end
