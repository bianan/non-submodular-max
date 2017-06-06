
ratio_param_names={'\gamma', '\gamma^G'};
nm_names = length(ratio_param_names);
n = pm.n;
max_k = n;  %

ratio_param_list = [1 2];
ratio_calced = 0; %   by setting to 1--> not calc again

%%
cur_param_names={'\alpha^{total}', '\alpha^G'};
nm_cur_names = length(cur_param_names);

cur_param_list = [1 2];
cur_calced = 0;

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
    load(ratio_file_name);
end

%% calc curvature param

file_name = [out_dir 'cur_pm_' data_name{data_id}  '_' subfix];
if 0 == cur_calced
    for exp_id = 1:nm_exps
        xs_greedy = results{exp_id,2}.xs;  %  solutions of fr
        fs_fr = results{exp_id,2}.fs;
        x_tra_fr = results{exp_id,2}.x_tra;
        cur_pm(exp_id) = calc_cur_pm(f, pm(exp_id), xs_greedy, fs_fr, x_tra_fr,   max_k);  %  slow, so only run once.
    end
    save(file_name, 'cur_pm');
else
    load(file_name);
end

%% draw ratio curvature  pms
plot_opt = {'-.xb',  '--^m', '--or',  '-.vg'};
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
pms = zeros(nm_exps, max_k, 3);

for exp_id = 1:nm_exps
    pms(exp_id, :,1) = cur_pm(exp_id).cur;
    pms(exp_id, :,2) = cur_pm(exp_id).cur_g;
    pms(exp_id, :,3) = ratio_pm(exp_id).gammaG;
end

mus=cell(1,3);
mucis=cell(1,3);

sigmas =cell(1,3);
for t = 1:3
    [mu, sigma, muci, ~]= normfit(squeeze(pms(:,:,t)), 0.05);
    mus{t} = mu;
    mucis{t} = muci;
    sigmas{t} = sigma;
end

x = 1:max_k;

for t = 1:3
    errorbar(x, mus{t}, sigmas{t}, plot_opt{t},'linewidth',0.3,'markersize', 1.5);
    hold on;
end
hold off;

legend({cur_param_names{cur_param_list}, ratio_param_names{ratio_param_list(2:end)}}, ...
    'Location','northoutside', 'Orientation', 'horizontal');
set(gca,'fontsize',6)
axis([1 max_k 0, 1.1])
xlabel('K');
ylabel('Parameters');
fig_name = [out_dir data_name{data_id} '_ratio_cur_param_' subfix];
saveas(hFig, fig_name, 'pdf');

