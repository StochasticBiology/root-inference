function SMC(N,epsilon, data_selection,model1, model2)
%Applies SMC to given models. If more than one model is implemented, apply
%model selection.

%N = number of points
%epsilon = final tolerance

%Model: 1 = Uniform branching, exponential growth law
%       2 = Uniform branching, linear growth law
%       3 = Minimally spaced branching, exponential growth law
%       4 = Linear fit
%       5 = Linear fit no c

%Data: 1 = Arabidopsis
%      2 = MtGFP
%      3 = Friendly
%      4 = CRootBox
%      5 = Linear fit

if ~exist('model2','var')
    % If second model is not implemented
    model2 = 0;
end
E = epsilon*[5 3 2 1.5 1]; % Tolerance vector
%E = epsilon;
sigma_initial = 0.1; %Standard deviation for peturbation kernel
T = numel(E); %Number of populations

if model2 > 0
    M = 2; %Number of models
else
    M = 1;
end

%Preallocate results vectors according to model selection and data
%From data
[Data,Variable_list] = dataInput(data_selection);
num_var = numel(Variable_list);

%From model

[All_models, Model1, Model2] = modelSelection(model1,model2);

for i = 1:All_models.num_param
    sigma.(All_models.Parameter_list{i}) = sigma_initial * (All_models.Priors.(All_models.Parameter_list{i})(2)-All_models.Priors.(All_models.Parameter_list{i})(1));
end
%Preallocate vectors
for i = 1:num_var
    rho_hits.(Variable_list{i}) = zeros(size(Data.(Variable_list{i}),1),size(Data.(Variable_list{i}),2),N);
    Output_hits.(Variable_list{i}) = zeros(size(Data.(Variable_list{i}),1),size(Data.(Variable_list{i}),2),N);
end
if model2>0
    W = zeros(N,T,M);
else
    W = zeros(N,T,1);
end

for i = 1:All_models.num_param
    Hits.(All_models.Parameter_list{i}) = zeros(N,T);
end
Hits.model_index = zeros(N,T);

for t = 1:T
    tolerance = E(t);
    Iterations = 0;
    hits = 0;
    while hits < N
        if t == 1
            %Pull model index if model selection implemented
            if M > 1
                Model_options = [model1 model2];
                r = randi([1, 2], 1);
                model_index = r;
            else
                model_index = 1;
                Model_options = model1;
            end
            if model_index == 1
                Current_Model = Model1;
            else
                Current_Model = Model2;
            end
            
            %Pull initial parameter values
           
            [Parameters] = parameterValues(Current_Model.Priors, Current_Model.num_param, Current_Model.Parameter_list,W, Model_options, Hits,t,M, sigma);
        else
            %Pull model index from model weightings
            if M > 1
                %Calculate weight for each model
                model_weights = zeros(1,2);
                for i = 1:M
                    model_weights(i) = sum(W(:,t-1,i));
                    
                end
                
                %Pull model index according to model weighting
                r = rand;
                model_choice = 0;
                sum_model_weights = 0;
                
                while r > sum_model_weights
                    model_choice = model_choice + 1;
                    sum_model_weights = sum_model_weights + model_weights(model_choice);
                    
                end
                
                if model_choice > 2
                    model_choice = model_choice;
                end
                model_index = model_choice;
            end
            
            %Pull parameter values from previous population according to
            %weightings
            if M > 1
                r = rand*model_weights(model_index);
            else
                r = rand;
            end
            
            if model_index == 1
                Current_Model = Model1; 
            else
                Current_Model = Model2;
            end
            
            
            for i = 1:Current_Model.num_param
                count = 1;
                sum_weights = W(1,t-1,model_index);
                while r > sum_weights
                    count = count + 1;
                    sum_weights = sum_weights + W(count,t-1,model_index);
                end
                Parameters.(Current_Model.Parameter_list{i}) = Hits.(Current_Model.Parameter_list{i})(count,t-1,model_index);
            end
            
        end
        %Perturb values
        for i = 1:Current_Model.num_param
            Temp_Parameters.(Current_Model.Parameter_list{i}) = Parameters.(Current_Model.Parameter_list{i}) + normrnd(0,sigma.(Current_Model.Parameter_list{i}));
            while Temp_Parameters.(Current_Model.Parameter_list{i}) < Current_Model.Priors.(Current_Model.Parameter_list{i})(1) || Temp_Parameters.(Current_Model.Parameter_list{i}) > Current_Model.Priors.(Current_Model.Parameter_list{i})(2)
                Temp_Parameters.(Current_Model.Parameter_list{i}) = Parameters.(Current_Model.Parameter_list{i}) + normrnd(0,sigma.(Current_Model.Parameter_list{i}));
            end
            Parameters.(Current_Model.Parameter_list{i}) = Temp_Parameters.(Current_Model.Parameter_list{i});
        end
        %Apply model
        [Output_data] = applyModel(Model_options(model_index), Parameters,Data, Variable_list, Current_Model.Parameter_list,num_var);
        
        %Compare outputs to data
        
        [rho_total,rho,Comparisons, Normalised_comparisons] = dataCompare(Data, Output_data,Variable_list,num_var);
        
        %Check if simulation is a hit
        if rho_total < tolerance
            hits = hits+1;
            for i = 1:num_var
                %rho_hits.(Variable_list{i})(:,:,hits) = Normalised_comparisons.(Variable_list{i});
                Output_hits.(Variable_list{i})(:,:,hits) = Output_data.(Variable_list{i});
            end
            
            for i = 1:Current_Model.num_param
                Hits.(Current_Model.Parameter_list{i})(hits,t,model_index) = Parameters.(Current_Model.Parameter_list{i});
            end
            Hits.model_index(hits,t) = model_index;
            
            
            % Calculate weighting for given hit
            W = weights(Current_Model.Priors, Hits, Current_Model.num_param, N,sigma,t,model_index, Current_Model.Parameter_list, W, hits,model1,model2);
            
        end
        
    end
    %Normalise the weightings for the given population
    %Sum all of the weights
    sum_weights = 0;
    if M > 1
        for j = 1:M
            sum_weights = sum_weights + sum(W(:,t,j));
        end
    else
        sum_weights = sum(W(:,t));
    end
    %Divide each element by sum
    if M > 1
        for j = 1:M
            
                W(:,t,j) = W(:,t,j)./(sum_weights);
            
        end
    else
        for i = 1:N
            W(i,t) = W(i,t)/sum_weights;
        end
    end
    
end

num_param = numel(All_models.Parameter_list);

Parameter_list = All_models.Parameter_list;

posteriorPlot(Hits,tolerance,All_models.Priors, data_selection,N,M, All_models.Parameter_list, All_models.num_param,T);

mkdir(['Results_e=' num2str(tolerance)]);
num_timesteps= size(Output_hits.(Variable_list{1}),1);
m_max= size(Output_hits.(Variable_list{1}),2);
if M > 1
    All_results = zeros(N, num_param+1);
    for i = 1:num_param
        All_results(:,i) = Hits.(Parameter_list{i})(:,t);
    end
        All_results(:,num_param + 1) = Hits.model_index(:,t);
else
    All_results = zeros(N, num_param);
    for i = 1:num_param
        All_results(:,i) = Hits.(Parameter_list{i})(:,t);
    end
end
dlmwrite([pwd '/Results_e=' num2str(tolerance) '/Results_F=' num2str(data_selection) '.txt'], All_results, 'precision', ' %.4f', 'newline', 'pc');

for timestep = 1:num_timesteps
    for plant = 1:m_max
        num_statistics = num_var-1;
        
        All_results = zeros(num_statistics,N);
       
        for i = 1:num_statistics
            All_results(i,:) =  Output_hits.(Variable_list{i})(timestep,plant,:);
        end
        

        dlmwrite([pwd '/Results_e=' num2str(tolerance) '/Output_data' num2str(timestep) '_plant_' num2str(plant) '_F=' num2str(data_selection) 'models=' num2str(model1) ',' num2str(model2) '.txt'], transpose(All_results), 'precision', ' %.4f', 'newline', 'pc');

    end
end


end

