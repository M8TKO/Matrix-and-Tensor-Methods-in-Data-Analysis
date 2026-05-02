function centers = BetweennessCent(A)
    n = size(A,1);
    centers = zeros(n,1);
    D = distances(graph(A));
    for node = 1 : n
        for s = 1 : n
        
            if( s == node )
                continue;
            end

            for t = 1 : n
                if( t == node || t == s )
                    continue;
                end

               [num1, num2] = ShortestPathsThroughANode(A, D, s, t, node);
               centers(node) = centers(node) + num1 / num2 ;
            end
            
        end
    end
    [~, centers] = sort(centers, 'descend');
end

function [num1, num2] = ShortestPathsThroughANode(A, D, s, t, node)
    num1 = 0;
    num2 = 0;
    n = size(A, 1);
    if( s == t )
        num2 = 1;
        return;
    end
    for k = 1:n
        if A(k, t) == 0
            continue;
        end
        if D(s, k) + 1 == D(s, t)
            [sub_num1, sub_num2] = ShortestPathsThroughANode(A, D, s, k, node);
            num1 = num1 + sub_num1;
            num2 = num2 + sub_num2;
            %num2 = num2 + 1;
            if k == node
                num1 = num1 + 1;
            end
               
        end
    end
end
