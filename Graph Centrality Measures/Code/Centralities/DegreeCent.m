function centers = DegreeCent(A, directed, direction)
    i = 2;
    if directed && strcmp(direction, "IN")
        i = 1;
    end
    s = sum(A, i);
    [~, centers] = sort(s, 'descend');
end
