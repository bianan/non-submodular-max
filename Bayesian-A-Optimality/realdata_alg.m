%% main function for running algs
f = @a_optimality_fn;
solver_names={'OPT',  'Greedy', 'SDP'};
nm_names = length(solver_names);
n = pm.n;
max_iter = n;  %

%%
i =1;   % i is fixed for real-world data
solver_list = [1 2 3];
for t = solver_list
    [xs, fs, x_tra, runtime] = launch_solver(f, pm,t,max_iter);
    results{i,t}.fs = fs; %  function value
    results{i,t}.xs  = xs;
    results{i,t}.x_tra  = x_tra;
    results{i,t}.runtime = runtime;
end

subfix = pm.subfix;
file_name = [out_dir 'results_' data_name{data_id}  '_' subfix];
save(file_name, 'results');

%% plot function value
close all
plot_opt = {'-or',  '-.ob', ':xm', '-.vg'};
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
out_fs = zeros(max_iter, nm_names);
for t = solver_list
    out_fs(:,t) =results{1,t}.fs';
end
min_fs = min(min(out_fs));
max_fs = max(max(out_fs));

for t = solver_list(1:end)
    plot(out_fs(:,t), plot_opt{t},'linewidth',0.4,'markersize', 0.5);
    hold on;
end
hold off;

legend(solver_names{solver_list}, ...
    'Location','best');
set(gca,'fontsize',6)
% set(gca, 'FontName', 'Times');
axis([1 max_iter min_fs, max_fs])
xlabel('K');
ylabel('A-optimality objective');
fig_name = [out_dir data_name{data_id} subfix];
saveas(hFig, fig_name, 'pdf');

%% plot ratios of function value
hFig = figure;
set(hFig, 'Units', 'centimeters');
set( hFig, 'Position', [0 0 fWidth fHeight]);
set(hFig,'PaperPositionMode','auto');
set(hFig, 'PaperUnits','centimeters', 'PaperSize', [fWidth fHeight],...
    'PaperPosition', [0 0 fWidth fHeight]);
set(hFig, 'Name', data_name{data_id});
% ----------------------------------------------
ratios_f = zeros(max_iter, 2);
for nm_idx = 1:2
    ratios_f(:,nm_idx) = out_fs(:,nm_idx+1)./out_fs(:,1);
end

min_fs = (min(min(ratios_f)));
max_fs = (max(max(ratios_f)));

x = 1:max_iter;
for t = 1:2
    plot(ratios_f(:,t), plot_opt{t+1},'linewidth',0.4,'markersize', 1.5);
    hold on;
end
hold off;

legend(solver_names{2:3}, ...
    'Location','best');
set(gca,'fontsize',6)
% set(gca, 'FontName', 'Times');
axis([1 max_iter .96 inf])
xlabel('K');
ylabel('Objective/OPT');
fig_name = [out_dir data_name{data_id} subfix '_ratio'];
saveas(hFig, fig_name, 'pdf');

