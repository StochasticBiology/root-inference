function B1 = canBranch(B1,Branch_Length, Apical_length, Basal_length,n,m)
%Creates a vector of branching rates for branches that can branch
i = 0;
while i < n
    i = i + 1;
    if Branch_Length(i) < Apical_length + Basal_length
        B1(i) = 0;
    end
end
end