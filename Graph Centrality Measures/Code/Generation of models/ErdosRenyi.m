function A = ErdosRenyi(n, p, directed)
    % Generira graf pomoću Erdős-Rényi modela : 

    % Svaki brid ima vjerojatnost p da se pojavi u grafu.
    %
    % Parametri:
    %   n         - broj vrhova u graf
    %   p         - vjerojatnost nastanka svakog brida
    %   directed  - ISTINA ili LAŽ, ovisno o tome je li graf usmjeren ili
    %               nije
    %
    % Povratna vrijednost:
    %   A         - matrica susjedstva generiranog grafa

    if directed
        A = (rand(n) < p) & ~eye(n);
    else
        upper_triangle = zeros(n); 
        for i = 1:n-1
            upper_triangle(i, i+1:end) = rand(1, n-i) < p; 
        end
        A = upper_triangle + ( upper_triangle )'; 
    end
end
