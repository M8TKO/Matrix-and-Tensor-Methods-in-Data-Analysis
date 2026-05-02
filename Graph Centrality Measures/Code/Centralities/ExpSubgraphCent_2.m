function centers = ExpSubgraphCent_2(A,beta)
    n=size(A,1);
    if( beta <= 0)
        disp("Beta je nepozitivan...");
        return;
    end
    P=fastExpm(beta*A);
    s=diag(P);
    [~,centers] = sort(s,'descend');
end