function [All_models, Model1, Model2] = modelSelection(model1,model2)
%Outputs priors for specified models
%Model: 1 = Uniform branching, exponential growth law
%       2 = Uniform branching, linear growth law
%       3 = Minimally spaced branching, exponential growth law
%       4 = Linear fit
switch model1
    case 1 %Uniform branching, exponential growth law
        Priors1.g  = [0 1.4];
        Priors1.b  = [0 1.4];
        Priors1.gl  = [0 1];
        Priors1.l_max  = [35 50];
    case 2 %Uniform branching, linear growth law
        Priors1.g  = [0 1.4];
        Priors1.b  = [0 1.4];
        Priors1.gl  = [0 1];
    case 3 %Minimally spaced branching, exponential growth law
        Priors1.g  = [0 1.4];
        Priors1.b  = [0 1.4];
        Priors1.gl  = [0 1];
        Priors1.l_max  = [5 20];
        Priors1.delta  = [0 1];
    case 4 %Linear fit
        Priors1.m  = [1 4];
        Priors1.c  = [0 2];
    case 5 
        Priors1.m  = [1 4];
end
Model1.Priors = Priors1;
Model1.Parameter_list = fieldnames(Model1.Priors);
Model1.num_param = numel(Model1.Parameter_list);
switch model2
    case 1 %Uniform branching, exponential growth law
        Priors.g  = [0 1.4];
        Priors.b  = [0 1.4];
        Priors.gl  = [0 1];
        Priors.l_max  = [5 40];
    case 2 %Uniform branching, linear growth law
        Priors.g  = [0 1.4];
        Priors.b  = [0 1.4];
        Priors.gl  = [0 1];
    case 3 %Minimally spaced branching, exponential growth law
        Priors.g  = [0 1.4];
        Priors.b  = [0 1.4];
        Priors.gl  = [0 1];
        Priors.l_max  = [5 40];
        Priors.delta  = [0 1];
     case 4 %Linear fit
        Priors.m  = [1 4];
        Priors.c  = [0 2];
    case 5 
        Priors.m  = [1 4];
end
if model2 > 1
Model2.Priors = Priors;
Model2.Parameter_list = fieldnames(Model2.Priors);
Model2.num_param = numel(Model2.Parameter_list);
else
   Model2.Priors = Priors1;
Model2.Parameter_list = fieldnames(Model2.Priors);
Model2.num_param = numel(Model2.Parameter_list);
end
if Model2.num_param > Model1.num_param
    All_models = Model2;
else
    All_models = Model1;
end
end