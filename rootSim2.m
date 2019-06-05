function [timestep,Output_data, Branch] = rootSim2(Output_data,Time_max, Time, Parameters,Branch,timestep,model_index,m, Model_type)
%Simulates one plant growing until time Time_max
%Thickening_Rate = 0.1; % Thickening rate
%Max_Width = 2; % Maximum width
Branch.apical_length = 0; %Length of apical zone
Branch.basal_length = 0; %Length of basal zone
Max_Length = 10;
%BR = [Parameters.b 0];

n = Branch.Number_of_Daughters(m)+1;

%BR(1,m) = Parameters.b;
if numel(Parameters.g) > 1
    Parameters.g = Parameters.g(m);
end

if numel(Parameters.b) > 1
    Parameters.b = Parameters.b(m);
end

    


while Time < Time_max
    %Find the branches that can branch, and their branching rates
    B1 = canBranch(Parameters.b, Branch.Length(:,m), Branch.apical_length, Branch.basal_length,n);
    
    a = sum(B1); % Calculate sum of branching rates
    
    %Calculate time until next branching event using the Gillespie
    %algorithm
    deltat = -log(rand)./a;
    
    %Check if time limit exceeded
    if Time + deltat > Time_max
        %Grow until Time_max and stop
        
        %Grow until Time_max
        deltat = Time_max - Time;
        Time = Time_max;
        %Update properties of root system over time deltat
        Branch.Length(:,m) = growBranches(Parameters,Branch.Length(:,m),deltat,m,n, Model_type, model_index);
        
        return;
        
    else
        %Update system until Time + deltat
        Time = Time + deltat; % Increase time counter
        
        %Update properties of root system over time deltat
        Branch.Length(:,m) = growBranches(Parameters,Branch.Length(:,m), deltat,m,n, Model_type, model_index);
        
        %Find branch point, if possible
        [Branch, Time,n] = pickBranchpoint(Model_type, model_index, Branch, Parameters,1,m,n, Time, Max_Length);
        
    end
    
    
end

   
end

