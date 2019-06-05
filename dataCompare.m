function [rho_total,rho, Comparisons, Normalised_comparisons] = dataCompare(Data, Output_data,Variable_list,num_var)
%Compares data to model output data
for j = 1:num_var
    m_max = size(Data.(Variable_list{j}),2);
    num_timesteps = size(Data.(Variable_list{j}),1);
    for timestep = 1:num_timesteps
        for m = 1:m_max
            
            Comparisons.(Variable_list{j})(timestep,m) = sqrt((Output_data.(Variable_list{j})(timestep,m) - Data.(Variable_list{j})(timestep,m))^2);
            
        end
    end
end

%Normalise comparisons
for j = 1:num_var
    sum = 0;
    max_value = max(max(Data.(Variable_list{j})));
    m_max = size(Data.(Variable_list{j}),2);
    num_timesteps = size(Data.(Variable_list{j}),1);
    for m = 1:m_max
        for timestep = 1:num_timesteps
            Normalised_comparisons.(Variable_list{j})(timestep,m) = Comparisons.(Variable_list{j})(timestep,m)/max_value;
            sum = sum + Normalised_comparisons.(Variable_list{j})(timestep,m);
        end
    end 
    rho.(Variable_list{j}) = sum;

end
rho_total = 0;
%rho_total = rho.l;
for j = 1:num_var
     rho_total = rho_total + rho.(Variable_list{j});
 end
 
 rho_total = rho_total/num_var;
end

