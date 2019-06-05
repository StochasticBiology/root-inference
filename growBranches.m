function f = growBranches(Parameters,Branch_Length, deltat,m,n, Model_type, model_selection)

if model_selection == 2
    Branch_Length(1) = Branch_Length(1) + Parameters.g*deltat;
else
    Branch_Length(1) = (Branch_Length(1)-Parameters.l_max)*exp(-(Parameters.g/Parameters.l_max)*deltat) + Parameters.l_max;
end

for i = 2:n %lateral roots
    %Length:
    if model_selection == 2
        Branch_Length(i) = Branch_Length(i) + Parameters.gl*deltat;
    else
        Branch_Length(i) = (Branch_Length(i)-Parameters.l_max)*exp(-(Parameters.gl/Parameters.l_max)*deltat) + Parameters.l_max;
    end
end

f = Branch_Length;

end