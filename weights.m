function W = weights(Priors, Hits, num_param, N,sigma,t,model_index, Variable_list, W, hits,model1,model2)
%Calculate weighting for given hit
% Model_choice = [model1 model2];
% switch Model_choice(model_index)
%     case 1 
%         Variable_list = {'g', 'b', 'gl', 'l_max'};
%     case 2
%         Variable_list = {'g', 'b', 'gl'};
%     case 3
%         Variable_list = {'g', 'b', 'gl', 'l_max', 'delta'};
%     case 4
%         Variable_list = {'m', 'c'};
%     case 5
%         Variable_list = {'m'};
% end
% 
% num_param = numel(Variable_list);
if t == 1
    W(hits,t,model_index) = 1;
else
    y = 0;
    for j = 1:N
        K = 0; 
        P = 1;
        for i = 1:num_param
            P = P *(Priors.(Variable_list{i})(2) - Priors.(Variable_list{i})(1));
            K = K + 1/(sqrt(2*pi*sigma.(Variable_list{i})^2))*exp(-((Hits.(Variable_list{i})(hits,t,model_index) - Hits.(Variable_list{i})(j,t-1,model_index))^2)/(2*sigma.(Variable_list{i})^2));
        end
        y = y + W(j,t-1,model_index) * K;
    end
    
%     y = 1;
%     for i = 1:num_param
%         x = 0;
%         for j = 1:N
%             x = x + (W(j,t-1,model_index)/sqrt(2*pi*sigma.(Variable_list{i})^2))*exp(-((Hits.(Variable_list{i})(hits,t,model_index) - Hits.(Variable_list{i})(j,t-1,model_index))^2)/(2*sigma.(Variable_list{i})^2));
%         end
%     y = y*(1/(x*(Priors.(Variable_list{i})(2) - Priors.(Variable_list{i})(1))));
%     end
    W(hits,t,model_index) = 1/(P*y);
end
end