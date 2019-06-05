function [Output_data] = applyModel(model_index, Parameters,Data, Variable_list, Parameter_list,num_var)
%Applies the model specified by model_index

%Model_index: 1 = Uniform branching, exponential growth law
%             2 = Uniform branching, linear growth law
%             3 = Minimally spaced branching, exponential growth law
%             4 = linear fit
if model_index == 4 || model_index == 5
    if model_index ==4
    x = [1:1:10];
    for i = 1:10
    Output_data.y(i) = Parameters.m * x(i) + Parameters.c;
    end
    Output_data.timesteps = 1;
    else
        x = [1:1:10];
        for i = 1:10
    Output_data.y(i) = Parameters.m * x(i);
    end
    Output_data.timesteps = 1;
    end
else
    for i = 1:num_var
      Output_data.(Variable_list{i}) = zeros(size(Data.(Variable_list{i}),1),size(Data.(Variable_list{i}),2));
    end
   num_timesteps = numel(Data.timesteps);
    m_max = size(Data.(Variable_list{1}),2);
    Time_max = Data.timesteps(num_timesteps);
    
    Plant.Num_branches = zeros(num_timesteps,m_max);
    Plant.Tap_root_length = zeros(num_timesteps,m_max);
    Plant.Lateral_mean = zeros(num_timesteps,m_max);
    Plant.Lateral_standard_deviation = zeros(num_timesteps,m_max);
    Plant.IBD_mean = zeros(num_timesteps,m_max);
    Plant.IBD_standard_deviation = zeros(num_timesteps,m_max);
    Plant.Max_Branches = 10*ceil(1.4*Time_max);
    
    Branch.Mother_Branch = zeros(Plant.Max_Branches,m_max);
    Branch.Mother_Length_at_branching = zeros(Plant.Max_Branches,m_max);
    Branch.Distance_Along_Mother = zeros(Plant.Max_Branches,m_max);
    Branch.x1 = zeros(Plant.Max_Branches,m_max);
    Branch.y1 = zeros(Plant.Max_Branches,m_max);
    Branch.Daughter_Branches = zeros(Plant.Max_Branches,m_max);
    Branch.Inter_Branch_Distances = zeros(Plant.Max_Branches,m_max);
    Branch.Start_Time = zeros(Plant.Max_Branches,m_max);
    
    %outputs
    Branch.Angle = zeros(Plant.Max_Branches,m_max);
    Branch.Length = zeros(Plant.Max_Branches,m_max);
    Branch.Width = zeros(Plant.Max_Branches,m_max);
    Branch.Order = zeros(Plant.Max_Branches,m_max);
    Branch.Number_of_Daughters = zeros(1,m_max);
    
    %Define initial branch
    Branch.Angle(1,:) = 3*pi/2; %Branch angle taken anticlockwise from x axis.
    %Branch.Length(1,:) = [0.896329447 0.306621043 1.034842845 1.111814233];
    Branch.Length(1,:) = [0.1];
    Branch.Width(1,:) = 0.01; %Initial diameter of root
    Branch.Order(1,:) = 1;
    
    for timestep = 1:num_timesteps
        
        for m = 1:m_max
            if timestep == 1
                Time = 0;
            else
                Time = Data.timesteps(timestep-1);
            end
      
            [timestep,Output_data, Branch] = rootSim2(Output_data,Data.timesteps(timestep), Time, Parameters,Branch,timestep,model_index,m,model_index);
            Output_data.l(timestep,m) = Branch.Length(1,m);
            Output_data.n(timestep,m) = Branch.Number_of_Daughters(1,m);
            
            index = nnz(Branch.Length(:,m));
            if index < 2
                Output_data.mu(timestep,m) = 0;
            else
                Output_data.mu(timestep,m) = mean(Branch.Length(2:nnz(Branch.Length(:,m)),m));
            end     
        end
        
        
    end
    
    
end

