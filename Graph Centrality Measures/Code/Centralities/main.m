n = 100;
m = 3;
beta = 0.1;
k = 8;
p = 0.1;
A = WattsStrogatz(n,k,p);
alpha = 2;
functionsAndParams = {
    @DegreeCent, {A, false};
    @ClosenessCent, {A}
    @EigenValueCent, {A,false};
    @KatzCent, {A, beta};
    @ExpSubgraphCent, {A, beta};
    @ResSubgraphCent, {A, beta};
    @TotalCommunicabilityCent,{ A, alpha};
    @BetweennessCent, {A};
};
results = zeros(n,size(functionsAndParams, 1));
for i = 1:size(functionsAndParams, 1)
    func = functionsAndParams{i, 1};
    params = functionsAndParams{i, 2};
    results(:,i) = func(params{:});
end
results = array2table(results);
results.Properties.VariableNames = {'DegreeCent', 'ClosenessCent', 'EigenValueCent','KatzCent','ExpSubgraphCent','ResSubgraphCent','TotalCommunicabilityCent','BetweennessCent'};

disp(results);

% x = -ones(n,1);
% x = abs(x);
% 
% [~,y] = sort(x, 'descend');
