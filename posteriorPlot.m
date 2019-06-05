function posteriorPlot(Hits,t,Prior, friendly,N,M, Parameter_list, num_params,T)
%Reduces vectors to correct size and produces posterior plot

% 
% for i = 1:num_params
%     Final_hits.(Parameter_list{i}) = nonzeros(Hits.(Parameter_list{i})(:,T,1));
%     if M > 1
%         for m = 2:M
%             if sum(Hits.(Parameter_list{i})(:,T,m)) > 0
%                 Final_hits.(Parameter_list{i}) = nonzeros(Hits.(Parameter_list{i})(:,T,m));
%             end
%         end
%     end
% end
% 
% for i = 1:num_params
%     for m = 1:M-1
%         if size(Final_hits.(Parameter_list{i}),3) > 1
%             Final_hits.(Parameter_list{i}) = [Final_hits.(Parameter_list{i})(:,m);Final_hits.(Parameter_list{i})(:,m+1)];
%         end
%     end
% end
% 
% for i = 1:num_params
%     figure
%     histogram(Final_hits.(Parameter_list{i}),  'Normalization', 'probability', 'FaceColor', 'r');
%    xlabel(Parameter_list{i});
%    ylabel('probability');
%end

if M > 1
    figure
    histogram(Hits.model_index(:,T));
end



end