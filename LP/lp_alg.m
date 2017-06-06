%% main function for running algs
solver_names={'OPT',  'Greedy'};
nm_names = length(solver_names);
n = pm.n;
max_iter = n;  %
solver_list = [1 2];
%%
i =1;   % index for repeated experimenmts
for i = 1:nm_exps
    for t = solver_list
        [xs, fs, x_tra, runtime] = launch_solver(f, pm(i),t,max_iter);
        %     fprintf('solver: %s, fs: %f, runtime: %d\n', solver_names{i}, fs, runtime);
        results{i,t}.fs = fs; %  function values
        results{i,t}.xs  = xs;
        results{i,t}.x_tra  = x_tra;
        results{i,t}.runtime = runtime;
    end
end
subfix = pm.subfix;
file_name = [out_dir 'results_' data_name{data_id}  '_' subfix];
save(file_name, 'results');

%% draw
close all
plot_opt = {'-or',  '-.xb', ':xm', '-.vg'};
fWidth=5;
fHeight=3;
% ----------------------------------------------
hFig = figure;
set(hFig, 'Units', 'centimeters');
set( hFig, 'Position', [0 0 fWidth fHeight]);
set(hFig,'PaperPositionMode','auto');
set(hFig, 'PaperUnits','centimeters', 'PaperSize', [fWidth fHeight],...
    'PaperPosition', [0 0 fWidth fHeight]);
set(hFig, 'Name', data_name{data_id});
% ----------------------------------------------
out_fs = zeros(nm_exps, max_iter, nm_names);

for i = 1:nm_exps
    for t = solver_list
        out_fs(i, :,t) =results{i,t}.fs';
    end
end


min_fs = min(min(min(out_fs)));
max_fs = max(max(max(out_fs)));

mus=cell(1,nm_names);
mucis=cell(1,nm_names);
sigmas =cell(1,nm_names);
for t = 1:nm_names
    [mu, sigma, muci, ~]= normfit(squeeze(out_fs(:,:,t)), 0.05);
    mus{t} = mu;
    mucis{t} = muci;
    sigmas{t} = sigma;
end
x = 1:max_iter;

for t = solver_list(1:end)
    errorbar(x, mus{t}, sigmas{t}, plot_opt{t},'linewidth',0.3,'markersize', 0.4);
    hold on;
end
hold off;

legend(solver_names{solver_list}, ...
    'Location','best');
set(gca,'fontsize',6)
% set(gca, 'FontName', 'Times');
axis([1 max_iter min_fs, max_fs])
xlabel('K');
ylabel('LP objective');
fig_name = [out_dir data_name{data_id} subfix];
saveas(hFig, fig_name, 'pdf');



