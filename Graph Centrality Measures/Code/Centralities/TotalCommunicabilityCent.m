function centers = TotalCommunicabilityCent(A,beta)

    if( beta <= 0 )
        disp("Beta je nepozitivan...");
        return;
    end

    n = size(A,1);
    TC = expm(beta*A)*ones(n,1);
    [~,centers] = sort(TC,'descend');
end