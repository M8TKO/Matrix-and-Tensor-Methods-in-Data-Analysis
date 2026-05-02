function A = WattsStrogatz(n,k,p)
    A = zeros(n,n);
    for i = 1 : n
        for j = 1 : k/2
            A(i,mod(i-j-1,n)+1)=1;
            A(i,mod(i+j-1,n)+1)=1;
            A(mod(i-j-1,n)+1,i)=1;
            A(mod(i+j-1,n)+1,i)=1;
        end
    end
    
    for i = 1 : n
        for j = 1 : k/2
            if( rand() >= p ) 
                continue;
            end
            
            A(i,mod(i+j-1,n)+1)=0;
            A(mod(i+j-1,n)+1,i)=0;
    
            new = i;
            while new == i || A(i,new) == 1
                new = randi(n);
            end

            A(i,new) = 1;
            A(new,i) = 1;
        end
    end
end