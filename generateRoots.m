function generateRoots(Parameters, Time_max, model_index)
%Simulates a root system with chosen parameters growing for a given amount of time, and outputs an image of
%the system

Variable_list = {'n', 'l','mu'};

num_var = numel(Variable_list);

for i = 1:num_var
    Output_data.(Variable_list{i}) = 0;
end

m = 1;
num_timesteps = 1, 
m_max = 1;

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
    
    
    if timestep == 1
        Time = 0;
    else
        Time = Data.timesteps(timestep-1);
    end
    
    [timestep,Output_data, Branch] = rootSim2(Output_data,Time_max, Time, Parameters,Branch,timestep,model_index,m,model_index);
    Output_data.l(timestep,m) = Branch.Length(1,m);
    Output_data.n(timestep,m) = Branch.Number_of_Daughters(1,m);
    
    index = nnz(Branch.Length(:,m));
    if index < 2
        Output_data.mu(timestep,m) = 0;
    else
        Output_data.mu(timestep,m) = mean(Branch.Length(2:nnz(Branch.Length(:,m)),m));
    end
    
    
    
end
h = exampleOutputs(Branch.x1, Branch.y1, Branch.Angle, Branch.Length, Parameters.b, Parameters.g, Parameters.gl,1,model_index,1,1,1,m, 1, 1,1, 1)


end

