function h = exampleOutputs(Branch_x1, Branch_y1, Branch_Angle, Branch_Length, b, g, gl,deltab,model_selection,friendly,rho_total,hits,m, Output_hits, rho,num_timesteps, repeat)
%Find the end points for all branches
if friendly == 1
    
     mkdir(['Friendly' num2str(repeat)]);
    
    
else
    
    mkdir(['MtGFP' num2str(repeat)]);
    
end

n = nnz(Branch_Length);
Branch_Angle(1) = 3*pi/2;

Branch_x2 = zeros(numel(Branch_x1),1);
Branch_y2 = zeros(numel(Branch_x1),1);


h = figure('Visible','off');


for i = 1:n
    Branch_x2(i) = Branch_x1(i) + Branch_Length(i) * cos(Branch_Angle(i));
    Branch_y2(i) = Branch_y1(i) + Branch_Length(i) * sin(Branch_Angle(i));
     
    x1 = Branch_x1(i);
    y1 = Branch_y1(i);
    x2 = Branch_x2(i);
    y2 = Branch_y2(i);
     
    x = linspace(x1, x2);
    y = ((y2-y1)/(x2-x1))*(x-x1)+y1;
    
    plot(x,y,'Color','black','LineWidth',0.75);
    pbaspect = [1,1];
    axis([-3.5 3.5 -7 0]);
    
    hold on
end
set(h,'Visible','on');

% text(-2,-0.2,['g = ' num2str(g)], 'Interpreter', 'Latex'); 
% text(-2,-0.4,['b = ' num2str(b)], 'Interpreter', 'Latex');
% text(-2,-0.6,['$\alpha$ = ' num2str(gl)], 'Interpreter', 'Latex');
% text(-2,-0.8,['$\delta$ = ' num2str(deltab)], 'Interpreter', 'Latex');
% text(-2,-1,['model index = ' num2str(model_selection)], 'Interpreter', 'Latex');
% 
% text(-2,-1.4,['n = ' num2str(Output_hits.n(num_timesteps,m,hits))], 'Interpreter', 'Latex');
% text(-2,-1.6,['l = ' num2str(Output_hits.l(num_timesteps,m,hits))], 'Interpreter', 'Latex');
% text(-2,-1.8,['$\mu$ = ' num2str(Output_hits.mu(num_timesteps,m,hits))], 'Interpreter', 'Latex');
% text(-2,-2,['$\sigma$ = ' num2str(Output_hits.sigma(num_timesteps,m,hits))], 'Interpreter', 'Latex');
% text(-2,-2.2,['$\mu_{ibd}$ = ' num2str(Output_hits.ibdm(num_timesteps,m,hits))], 'Interpreter', 'Latex');
% text(-2,-2.4,['$\sigma_{ibd}$ = ' num2str(Output_hits.ibdsd(num_timesteps,m,hits))], 'Interpreter', 'Latex');
% text(-2,-2.6,['min ibd = ' num2str(Output_hits.min_ibd(num_timesteps,m,hits))], 'Interpreter', 'Latex');
% 
% text(-2,-3,['$\rho$ = ' num2str(rho_total)], 'Interpreter', 'Latex');
% text(-2,-3.2,['$\rho_n$ = ' num2str(rho.n)], 'Interpreter', 'Latex');
% text(-2,-3.4,['$\rho_l$ = ' num2str(rho.l)], 'Interpreter', 'Latex');
% text(-2,-3.6,['$\rho_{\mu}$ = ' num2str(rho.mu)], 'Interpreter', 'Latex');
% text(-2,-3.8,['$\rho_{\sigma}$ = ' num2str(rho.sigma)], 'Interpreter', 'Latex');
% text(-2,-4,['$\rho_{\mu_{ibd}}$ = ' num2str(rho.ibdm)], 'Interpreter', 'Latex');
% text(-2,-4.2,['$\rho_{\sigma_{ibd}}$ = ' num2str(rho.ibdsd)], 'Interpreter', 'Latex');
% text(-2,-4.4,['$\rho_{min\_ibd}$ = ' num2str(rho.min_ibd)], 'Interpreter', 'Latex');
% text(-2,-4.6,['$\rho_\phi$ = ' num2str(rho.phi)], 'Interpreter', 'Latex');

if friendly == 1
saveas(h, [pwd '/Friendly' num2str(repeat) '/exampleplot_model' num2str(model_selection) 'g=' num2str(g) 'b=' num2str(b) 'gl=' num2str(gl) '.png']);
else
   saveas(h, [pwd '/MtGFP' num2str(repeat) '/exampleplot_model' num2str(model_selection) 'g=' num2str(g) 'b=' num2str(b) 'gl=' num2str(gl) 'repeat' num2str(hits)  '.png']);
 
end
end