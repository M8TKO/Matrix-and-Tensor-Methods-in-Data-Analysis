function A = BarabasiAlbert(n,m)

    A = zeros(n,n);
    A(1:m+1,1:m+1) = ~eye(m+1);

    probConnection = [(1/(m+1))*ones(1,m+1),zeros(1,n -(m+1))];
    degrees = sum(A, 2)';
    numDegrees = (m+1)*m;

    for node = m+2 : n
        newNodes = datasample(1:node-1, m, 'Replace', false, 'Weights', probConnection(1:node-1));
        A(node,newNodes) = 1;
        A(newNodes,node) = 1;
        numDegrees = numDegrees + 2*m;
        degrees(newNodes) = degrees(newNodes) + 1; 
        degrees(node) = m;
        probConnection = degrees / numDegrees;
    end
end
