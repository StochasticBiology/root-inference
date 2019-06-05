function [Branch, Time, n] = pickBranchpoint(Model_type, model_index, Branch, Parameters,Branching_meristem,m,n, Time, Max_Length)
%Find branching point and update branch properties
Initial_Length = 0.1;
%alpha = 2/3; % Branching factor
Initial_Width = 0.8; % Width of new roots
if model_index == 3
    model_index = 4; 
end

if model_index == 2
    model_index = 1;
end

global reject


if Model_type == 2
    model_index = 1;
end
switch model_index
    case 1
        d = rand;
        Branch.Distance_Along_Mother(n+1,m) = d*(Branch.Length(Branching_meristem,m)-Branch.apical_length - Branch.basal_length) + Branch.basal_length;
        Branch.x1(n+1,m) = 0;
        Branch.y1(n+1,m) = -Branch.Distance_Along_Mother(n+1,m);
        %Branch.x1(n+1,m) = Branch.x1(Branching_meristem,m) + (Branch.basal_length + d*(Branch.Length(:,m)(Branching_meristem,m) - Branch.basal_length - Branch.apical_length))*cos(Branch.Angle(Branching_meristem,m));
        %        Branch.y1(n+1,m) = Branch.y1(Branching_meristem,m) + (Branch.basal_length + d*(Branch.Length(:,m)(Branching_meristem,m) - Branch.basal_length - Branch.apical_length))*sin(Branch.Angle(Branching_meristem,m));
        %        Branch.Distance_Along_Mother(n+1,m) = ((Branch.x1(n+1,m)-Branch.x1(Branching_meristem,m))^2 + (Branch.y1(n+1,m) - Branch.y1(Branching_meristem,m))^2)^0.5;
        
    case 2
        viable_branch_points = 0; %Still need a dowhile...
        
        while any(viable_branch_points) == 0
            
            %Create vector of potential branch sites.
            num_branch_points = floor((Branch.Length(1,m) - Branch.apical_length - Branch.basal_length)/Parameters.deltap2);
            if num_branch_points > 0
                branch_points = zeros(1,num_branch_points);
                branch_points(1) = Branch.basal_length + Parameters.parameter;
                
                for i = 2:num_branch_points
                    branch_points(i) = branch_points(i-1) + Parameters.parameter;
                end
                
                %Create boolean vector of viable branch points
                viable_branch_points = not(ismember(branch_points,Branch.Distance_Along_Mother(2:n,m)));
                
            end
            if any(viable_branch_points) == 1
                a = 0;
                while a == 0
                    r = randi(num_branch_points);
                    a = viable_branch_points(r);
                end
                
            else
                return;
                
                
            end
            
            
        end
        
        Branch.Distance_Along_Mother(n+1,m) = branch_points(r);
        Branch.y1(n+1,m) = -Branch.Distance_Along_Mother(n+1,m);
        Branch.x1(n+1,m) = 0;
        
    case 3
        no_branch_sites = floor((Branch.Length(1,m) - Branch.apical_length - Branch.basal_length)/Parameters.parameter + 1);
        x = -1;
        while (x < 0) || (x > Branch.Length(1,m))
            if (no_branch_sites > 1)
                
                mu_model = (randi(no_branch_sites)-1)*Parameters.parameter + Branch.basal_length;
                %sigma_model = Parameters.parameter/Parameters.sigma3;
                sigma_model = Parameters.sigma3;
            else
                mu_model = Parameters.parameter;
                %sigma_model = Parameters.parameter / Parameters.sigma3;
                sigma_model = Parameters.sigma3;
            end
            
            %Distance cannot be nonzero or greater than the branch
            %length
            
            x = normrnd(mu_model,sigma_model);
        end
        Branch.Distance_Along_Mother(n+1,m) = x;
        Branch.y1(n+1,m) = -Branch.Distance_Along_Mother(n+1,m);
        Branch.x1(n+1,m) = 0;
    case 4
        if n == 1
            d = rand;
            x = d*(Branch.Length(Branching_meristem,m)-Branch.apical_length - Branch.basal_length) + Branch.basal_length;
            if (x < Parameters.delta) || (Branch.Length(Branching_meristem,m) - x < Parameters.delta)
                return
            else
            Branch.Distance_Along_Mother(n+1,m) = x;
             Branch.x1(n+1,m) = 0;
            Branch.y1(n+1,m) = -Branch.Distance_Along_Mother(n+1,m);
            end
        else
            
            %Create vector of existing branch sites
            branch_sites = Branch.Distance_Along_Mother(2:n,m);
            
            %Pull potential branch site from normal distribution
            d = rand;
            x = d*(Branch.Length(Branching_meristem,m)-Branch.apical_length - Branch.basal_length) + Branch.basal_length;
            
            y = abs(branch_sites - x);
            
            if any(y < Parameters.delta) || (x < Parameters.delta) || (Branch.Length(Branching_meristem,m) - x < Parameters.delta)
                return;
            else
                Branch.Distance_Along_Mother(n+1,m) = d*(Branch.Length(Branching_meristem,m)-Branch.apical_length - Branch.basal_length) + Branch.basal_length;
                Branch.x1(n+1,m) = 0;
                Branch.y1(n+1,m) = -Branch.Distance_Along_Mother(n+1,m);
               
            end
        end
        
        
        %         x = 0;
        %         while x == 0
        %             x = (Branch.Length(1,m) - Branch.apical_length - Branch.basal_length - (n-1)*2*Parameters.parameter)*rand;
        %
        %
        %             if (n > 1) && (x > 0)
        %                 Distances = sort(Branch.Distance_Along_Mother(2:n,m));
        %                 for j = 1:(n-1)
        %                     if j > numel(Distances)
        %
        %
        %                     end
        %                     if x > Distances(j) - Parameters.parameter;
        %                         x = x + 2*Parameters.parameter;
        %
        %                     end
        %                 end
        %             else
        %                 if n > 1
        %                     reject = 1;
        %                     return;
        %                 end
        %             end
        %
        %
        %         end
        %
        %         Branch.Distance_Along_Mother(n+1,m) = x;
        %         Branch.y1(n+1,m) = -Branch.Distance_Along_Mother(n+1,m);
        %         Branch.x1(n+1,m) = 0;
    case 5
        %Previous Model 5:
        %Branch.Distance_Along_Mother(n+1,m) = Branch.Distance_Along_Mother(n,m) + rand*(Branch.Length(:,m)(1,m) - Branch.Distance_Along_Mother(n,m) - Branch.apical_length);
        %Branch.y1(n+1,m) = -Branch.Distance_Along_Mother(n+1,m);
        %Branch.x1(n+1,m) = 0;
        
        %New Model 5:
        %Find lowest branch point
        
        lowest_branch = -min(Branch.y1(:,m));
        
        %Apply Model 3 below lowest branch point
        no_branch_sites = floor((Branch.Length(1,m) - lowest_branch - Branch.basal_length)/Parameters.parameter + 1);
        x = -1;
        while (x < 0) || (x > Branch.Length(1,m))
            if (no_branch_sites > 1)
                
                mu_model = (randi(no_branch_sites)-1)*Parameters.parameter + Branch.basal_length + lowest_branch;
                %sigma_model = Parameters.parameter/Parameters.sigma3;
                sigma_model = Parameters.sigma5;
            else
                mu_model = Parameters.parameter;
                %sigma_model = Parameters.parameter / Parameters.sigma3;
                sigma_model = Parameters.sigma5;
            end
            
            %Distance cannot be nonzero or greater than the branch
            %length
            
            x = normrnd(mu_model,sigma_model);
        end
        Branch.Distance_Along_Mother(n+1,m) = x;
        Branch.y1(n+1,m) = -Branch.Distance_Along_Mother(n+1,m);
        Branch.x1(n+1,m) = 0;
end
%Find which meristem will branch
        %Branching_meristem = whichBranch(B1); % The branching meristem
        Branching_meristem = 1;
        
        %Create new branch
        Branch.Start_Time(n+1,m) = Time;
        
        %Branching direction related to angle of mother branch
        Mother_angle = Branch.Angle(Branching_meristem,m);
        
        Branch.Angle(n+1,m) = branchingAngle(Mother_angle);
        
        Branch.Length(n+1,m) = 0.0001;
        Branch.Width(n+1,m) = Initial_Width;
        Branch.Mother_Branch(n+1,m) = Branching_meristem;
        Branch.Order(n+1,m) = Branch.Order(Branching_meristem,m) + 1;
        Branch.Mother_Length_at_Branching(n+1,m) = Branch.Length(Branching_meristem,m);
        
        % Update properties of mother branch
        Branch.Number_of_Daughters(Branching_meristem,m) = Branch.Number_of_Daughters(Branching_meristem,m) + 1;
        Branch.Daughter_Branches(Branch.Number_of_Daughters(1,m),1,m) = n+1;
        
        %Update inter-branch distances for mother branch
        Branch.Inter_Branch_Distances = InterBranchDistances(Branch.Distance_Along_Mother, Branch.Inter_Branch_Distances, Branching_meristem,m,Branch.Number_of_Daughters(:,m),n);
        
        n = n+1; %Increase branch counter


end

