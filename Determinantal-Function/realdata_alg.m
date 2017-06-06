%% main function for running algs

solver_names={'OPT',  'Greedy'};
nm_names = length(solver_names);
n = pm(1).n;
max_iter = n;  %

%%
i =1;   %
solver_list = [1 2];
for i = 1:nm_exps
    for t = solver_list
        [xs, fs, x_tra, runtime] = launch_solver(f, pm(i),t,max_iter);
        results{i,t}.fs = fs; %  function value
        results{i,t}.xs  = xs;
        results{i,t}.x_tra  = x_tra;
        results{i,t}.runtime = runtime;
    end
end

subfix = pm(1).subfix;
file_name = [out_dir 'results_' data_name{data_id}  '_' subfix];
save(file_name, 'results');

%% function value
plot_opt = {'-or',  '-.xb', ':xm', '-.vg'};
% close all
fWidth=5;
fHeight=4;
% ----------------------------------------------
%
hFig = figure;
set(hFig, 'Units', 'centimeters');
set( hFig, 'Position', [0 0 fWidth fHeight]);
set(hFig,'PaperPositionMode','auto');
set(hFig, 'PaperUnits','centimeters', 'PaperSize', [fWidth fHeight],...
    'PaperPosition', [0 0 fWidth fHeight]);
set(hFig, 'Name', data_name{data_id});
% ----------------------------------------------
out_fs = zeros(nm_exps, max_iter, 2);
for i = 1:nm_exps
    for t = solver_list
        out_fs(i,:,t) =results{i,t}.fs';
    end
    
end
min_fs = min(min(min(out_fs)));
max_fs = max(max(max(out_fs)));


x = 1:max_iter;
if nm_exps > 1
    
    mus=cell(1,2);
    mucis=cell(1,2);
    sigmas =cell(1,2);
    for t = 1:2
        [mu, sigma, muci, ~]= normfit(squeeze(out_fs(:,:,t)), 0.05);
        mus{t} = mu;
        mucis{t} = muci;
        sigmas{t} = sigma;
    end
    
    
    for t = solver_list(1:end)
        errorbar(x, mus{t}, sigmas{t}, plot_opt{t},'linewidth',0.3,'markersize', .4);
        hold on;
    end
else
    for t = solver_list(1:end)
        plot(x, out_fs(1,:,t), plot_opt{t},'linewidth',0.3,'markersize', .4);
        hold on;
    end
end
hold off;

legend(solver_names{solver_list}, ...
    'Location','best');
set(gca,'fontsize',6)
% set(gca, 'FontName', 'Times');
axis([1 max_iter min_fs, max_fs])
xlabel('K');
ylabel('Det. objective');
fig_name = [out_dir data_name{data_id} subfix];
saveas(hFig, fig_name, 'pdf');



