ratio_param_names={'\gamma^K', '\gamma^G'};
nm_names = length(ratio_param_names);
n = pm(1).n;
max_k = n;  %

ratio_param_list = [1 2];
ratio_calced = 0; %  after calculating one, can  set to be 1

%%  calc submodularity ratio parameter
subfix = pm(1).subfix;
ratio_file_name = [out_dir 'ratio_pm_' data_name{data_id}  '_' subfix];

if 0 == ratio_calced
    for exp_id = 1:nm_exps
        xs_greedy = results{exp_id,2}.xs;  %  solutions of greedy
        fs_greedy = results{exp_id,2}.fs;  %  objectives of greedy
        ratio_pm(exp_id) = calc_ratio_pm(f, pm(exp_id), xs_greedy, fs_greedy,  max_k);  %  slow, so only run once.
        
    end
    save(ratio_file_name, 'ratio_pm');
else
    
    load(ratio_file_name)
    
end

%% draw ratio pms
plot_opt = {'-.xb', '--^m', '--or',  '-.vg'};
%
% close all
fWidth=5;
fHeight=4;
% ----------------------------------------------
hFig = figure;
set(hFig, 'Units', 'centimeters');
set( hFig, 'Position', [0 0 fWidth fHeight]);
set(hFig,'PaperPositionMode','auto');
set(hFig, 'PaperUnits','centimeters', 'PaperSize', [fWidth fHeight],...
    'PaperPosition', [0 0 fWidth fHeight]);
set(hFig, 'Name', data_name{data_id});
% ----------------------------------------------
pms= zeros(nm_exps, max_k);

for i = 1:nm_exps
    pms(i,:)= ratio_pm(i).gammaG;
end

min_fs = min(min(pms));
max_fs = max(max(pms));

x = 1:max_k;
if nm_exps > 1
    
    [mu, sigma, muci, ~]= normfit(squeeze(pms), 0.05);
    
    errorbar(x, mu, sigma, plot_opt{3},'linewidth',0.3,'markersize', 1.5);
    
else
    plot(x, pms, plot_opt{3},'linewidth',0.3,'markersize', 1.5);
    
end

legend(ratio_param_names{ratio_param_list(2)}, ...
    'Location','best');
set(gca,'fontsize',6)
% set(gca, 'FontName', 'Times');
axis([1 max_k 0, max_fs])
% axis TIGHT
xlabel('K');
ylabel('Parameters');
fig_name = [out_dir data_name{data_id} '_param_' subfix];
saveas(hFig, fig_name, 'pdf');


