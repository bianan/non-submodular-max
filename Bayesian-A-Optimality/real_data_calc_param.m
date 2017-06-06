ratio_param_names={'\gamma', '\gamma^G'};
nm_names = length(ratio_param_names);

ratio_param_list = [1 2];
ratio_calced = 0; % one can set it to be 1 after it is  calculated once, since it is
% very time consuming

%%
cur_param_names={'\alpha^{total}', '\alpha^G'};
nm_cur_names = length(cur_param_names);
n = pm.n;
max_k = n;  %

cur_param_list = [1 2];
cur_calced = 0;  % one can set it to be 1 after it is  calculated once, since it is
% very time consuming

%%  calc submodularity ratio parameter
subfix = pm.subfix;
ratio_file_name = [out_dir 'ratio_pm_' data_name{data_id}  '_' subfix];

if 0 == ratio_calced
    
    xs_greedy = results{1,2}.xs;  %  solutions of greedy
    fs_greedy = results{1,2}.fs;  %  objectives of greedy
    ratio_pm = calc_ratio_pm(f, pm, xs_greedy, fs_greedy,  max_k);  %  slow
    save(ratio_file_name, 'ratio_pm');
    
else
    
    load(ratio_file_name);
    
end

%% calc curvature param
cur_file_name = [out_dir 'cur_pm_' data_name{data_id}  '_' subfix];
if 0 == cur_calced
    
    xs_greedy = results{1,2}.xs;  %  solutions of Greedy
    fs_fr = results{1,2}.fs;
    x_tra_fr = results{1,2}.x_tra;
    n = pm.n;
    max_k = n;
    
    cur_pm = calc_cur_pm(f, pm, xs_greedy, fs_fr, x_tra_fr,   max_k);  %  slow
    
    save(cur_file_name, 'cur_pm');
else
    load(cur_file_name);
    
end

%% draw ratio curvature  pms
plot_opt = {'-.xb', '--^m', '--or', '-.vg'};
close all
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

pms = zeros(n, nm_names);
pms(:,1) = cur_pm.cur;
pms(:,2) = cur_pm.cur_g;

for t = cur_param_list(1:end)
    plot(pms(:,t), plot_opt{t},'linewidth',0.5,'markersize', 2);
    hold on;
end


pms = zeros(max_k, nm_names);
pms(:,1) = ratio_pm.gammaK;
pms(:,2) = ratio_pm.gammaG;


for t = ratio_param_list(2:end)
    plot(pms(:,t), plot_opt{t+1},'linewidth',0.5,'markersize', 2);
    hold on;
end
hold off;

legend({cur_param_names{cur_param_list}, ratio_param_names{ratio_param_list(2:end)}}, ...
    'Location','best');
set(gca,'fontsize',6)
axis([2 max_k-1 0.8, 1])
xlabel('K');
ylabel('Parameters');
fig_name = [out_dir data_name{data_id} '_ratio_cur_param_' subfix];
saveas(hFig, fig_name, 'pdf');

% draw bounds
if 1
    % close all
    fWidth=5;
    fHeight=4;
    hFig = figure;
    set(hFig, 'Units', 'centimeters');
    set( hFig, 'Position', [0 0 fWidth fHeight]);
    set(hFig,'PaperPositionMode','auto');
    set(hFig, 'PaperUnits','centimeters', 'PaperSize', [fWidth fHeight],...
        'PaperPosition', [0 0 fWidth fHeight]);
    set(hFig, 'Name', data_name{data_id});
    % ----------------------------------------------
    bounds_names={'1/\alpha^G(1-exp(-\alpha^G\gamma^G))', '1/\alpha^G[1-((K-\alpha^G\gamma^G)/K)^K]'};
    ratio_g = ratio_pm.gammaG;
    cur_g = cur_pm.cur_g;
    n = length(cur_g);
    
    bounds = zeros(n,2);  %  first column:  constant bound, second: adaptive bound
    for k = 1:n
        if cur_g(k) ==0
            bounds(k, :) = ratio_g(k);
        else
            bounds(k, 1) = (1-exp(-cur_g(k)*ratio_g(k)))/cur_g(k);
            bounds(k,2) = (1 - power((k-cur_g(k)*ratio_g(k))/k, k))/cur_g(k);
        end
    end
    
    
    for t = 1:2
        plot(bounds(:,t), plot_opt{t},'linewidth',0.5,'markersize', 2);
        hold on;
    end
    hold off;
    
    h=legend(bounds_names{1:2}, ...
        'Location','best');
    % set(h,'Interpreter','latex');
    set(gca,'fontsize',6)
    axis([1 n  0, 1])
    xlabel('K');
    ylabel('Bounds');
    fig_name = [out_dir data_name{data_id} '_bounds_' subfix];
    saveas(hFig, fig_name, 'pdf');
end
