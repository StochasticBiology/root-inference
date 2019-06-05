function f = InterBranchDistances(Branch_Distance_Along_Mother, Branch_Inter_Branch_Distances, Branching_meristem,m,Branch_Number_of_Daughters,n)
if Branch_Distance_Along_Mother(n+1,m) > sum(Branch_Inter_Branch_Distances(:,m)) %If the new branch is the furthest along the mother
    j = Branch_Number_of_Daughters(Branching_meristem);
    
    if j > 1
        x = sum(Branch_Inter_Branch_Distances(:,m));
        
        Branch_Inter_Branch_Distances(j,m) = Branch_Distance_Along_Mother(n+1,m) - x;
    else
        
        Branch_Inter_Branch_Distances(1,m) = Branch_Distance_Along_Mother(n+1,m);
        
    end
    
else
    
    y = 0;
    i = 0;
    % Find where the new branch should fit in the inter-branch
    % distances matrix
    
    while y < Branch_Distance_Along_Mother(n+1,m)
        i = i + 1;
        y = y + Branch_Inter_Branch_Distances(i,m);
        
    end
    if y == 0
        i = 1;
    end
    
    j = Branch_Number_of_Daughters(1);
    
    %Move all elements above i-1 up one
    
    while j > i
       
        
        Branch_Inter_Branch_Distances(j,m) = Branch_Inter_Branch_Distances(j-1,m);
        j = j - 1;
    end
    
    %Insert IBD for new root
    if i>1
        %Find the sum of all IBDs before new branch
        k = 1;
        y = 0;
        
        while k < i
            y = y + Branch_Inter_Branch_Distances(k,m);
            k = k + 1;
        end
        
        Branch_Inter_Branch_Distances(i,m) = Branch_Distance_Along_Mother(n+1,m) - y;
    else
        Branch_Inter_Branch_Distances(i,m) = Branch_Distance_Along_Mother(n+1,m);
    end
    
    
    % Update IBD for root below the new one
    
    Branch_Inter_Branch_Distances(i+1,m) =Branch_Inter_Branch_Distances(i+1,m) - Branch_Inter_Branch_Distances(i,m);
    
end
f = Branch_Inter_Branch_Distances;
end