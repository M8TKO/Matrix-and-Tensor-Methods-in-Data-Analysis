function centers = ExpSubgraphCent(A,beta)
    
    if( beta <= 0)
        disp("Beta je nepozitivan...");
        return;
    end

    s = diag(expm(beta*A));
    [~,centers] = sort(s,'descend');
end