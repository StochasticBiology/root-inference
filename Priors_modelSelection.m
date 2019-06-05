function [Priors,Parameter_list1,Parameter_list2] = Priors_modelSelection(model1,model2)
%Outputs priors for specified models
%Model: 1 = Uniform branching, exponential growth law
%       2 = Uniform branching, linear growth law
%       3 = Minimally spaced branching, exponential growth law
%       4 = Linear fit
switch model1
    case 1 %Uniform branching, exponential growth law
        Priors.g  = [0 3];
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
        Priors.l_max  = [5 20];
        Priors.delta  = [0 1];
    case 4 %Linear fit
        Priors.m  = [1 4];
        Priors.c  = [0 2];
    case 5 
        Priors.m  = [1 4];
        
end
switch model2
    case 1 %Uniform branching, exponential growth law
        Priors2.g  = [0 1.4];
        Priors2.b  = [0 1.4];
        Priors2.gl  = [0 1];
        Priors2.l_max  = [5 40];
    case 2 %Uniform branching, linear growth law
        Priors2.g  = [0 1.4];
        Priors2.b  = [0 1.4];
        Priors2.gl  = [0 1];
    case 3 %Minimally spaced branching, exponential growth law
        Priors2.g  = [0 1.4];
        Priors2.b  = [0 1.4];
        Priors2.gl  = [0 1];
        Priors2.l_max  = [5 40];
        Priors2.delta  = [0 1];
     case 4 %Linear fit
        Priors2.m  = [1 4];
        Priors2.c  = [0 2];
    case 5 
        Priors2.m  = [1 4];
end
Parameter_list1 = fieldnames(Priors);
Parameter_list2 = fieldnames(Priors2);

if numel(Parameter_list2) > numel(Parameter_list1)
    Priors = Priors2;
end
end