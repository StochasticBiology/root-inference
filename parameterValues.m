function [Parameters] = parameterValues(Priors, num_param, Parameter_list,W, Models, Hits,t,M,sigma_deviation)
%PARAMETERVALUES Pulls parameter values for use in simulation

for i = 1:num_param
    Parameters.(Parameter_list{i}) = Priors.(Parameter_list{i})(2)*2;
end

for i = 1:num_param
    while (Parameters.(Parameter_list{i}) < Priors.(Parameter_list{i})(1) == 1) || (Parameters.(Parameter_list{i}) > Priors.(Parameter_list{i})(2) ==1 )
        if t == 1 %take parameter values from initial posterior
            Parameters.(Parameter_list{i}) = (Priors.(Parameter_list{i})(2) - Priors.(Parameter_list{i})(1))*rand + Priors.(Parameter_list{i})(1);
            
        else %Pull parameters from previous hits
            w_model = zeros(1,M);
            for j = 1:M
                w_model(1,j) = sum(W(:,t-1,j));
            end
            r = rand;
            k = 0;
            j = 0;
            while j < r
                j = j + 1;
                k = k + w_model(j);
                
            end
            model_index = Models(j);
            
            %Pull values based on weightings
            x = sum(W(:,t-1,model_index));
            n = rand*x;
            j = 0;
            w = 0;
            while w < n
                j = j + 1;
                w = w + W(j,t-1, model_index);
            end
            if j == 0
                j = 1;
            end
            
            Parameters.(Parameter_list{i}) = Hits.(Parameter_list{i})(j,t-1) + normrnd(0,sigma_deviation,1);
            
        end
        
    end
end

end

