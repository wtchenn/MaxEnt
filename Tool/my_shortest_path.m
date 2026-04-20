function D_path = my_shortest_path(i,A,D)

N = size(A,1);
    
    
unvisited = ones(1,N);
tempD = ones(1,N) * inf;
tempD(i) = 0;
while ((max(unvisited)==1)&&(min(tempD(find(unvisited==1))))<inf)
    [~,P] = min(tempD(find(unvisited==1)));
    temp = find(unvisited==1);
    P = temp(P);
    
    neighbor = find(A(P,:)==1);
    unvisited(P) = 0;
    for j = 1:length(neighbor)
        if((tempD(P) + D(P,neighbor(j))) <tempD(neighbor(j)))
            tempD(neighbor(j)) = tempD(P) + D(P,neighbor(j));
        end
    end
end 
D_path = tempD;