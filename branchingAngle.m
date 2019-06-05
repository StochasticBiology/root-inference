function f = branchingAngle(Mother_angle)
%Branching direction related to angle of mother branch
r = rand;
%if Mother_angle > 3*pi/2
%    if r > 0.5
%        Branch_Angle = Mother_angle + (2*pi-Mother_angle)/2;
%    else
%        Branch_Angle = Mother_angle - (Mother_angle -3*pi/2)/2;
%    end
%    
%elseif Mother_angle < 3*pi/2
%    if r < 0.5
    %    Branch_Angle = Mother_angle - (Mother_angle -pi)/2;
   % else
  %      Branch_Angle = Mother_angle + (3*pi/2-Mother_angle)/2;
 %   end
%else
    if r > 0.5
        Branch_Angle = 7*pi/4;
    else
        Branch_Angle = 5*pi/4;
    end
    
%end
f = Branch_Angle;
end