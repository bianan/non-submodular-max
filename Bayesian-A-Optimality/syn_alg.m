%% main function for running algs
close all;

f = @a_optimality_fn;
solver_names={'OPT',  'Greedy', 'SDP'};
nm_names = length(solver_names);
n = pm(1).n;
max_iter = n;  %
solver_list = [1 2 3];

%%
i =1;   % index for repeated experimenmts
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

%% plot function values
close all
plot_opt = {'-or',  '-.ob', ':xm', '-.vg'};

fWidth=5;
fHeight=4;
% ----------------------------------------------
%  mean of function value
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
%
for t = solver_list(1:nm_names)
    errorbar(x, mus{t}, sigmas{t}, plot_opt{t},'linewidth',0.3,'markersize', 0.4)
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

ratios_f = zeros(nm_exps, max_iter, 2);
for nm_idx = 1:2
    ratios_f(:,:,nm_idx) = out_fs(:,:,nm_idx+1)./out_fs(:,:,1);
end


min_fs = min(min(min(ratios_f)));
max_fs = max(max(max(ratios_f)));

mus2=cell(1,nm_names-1);
mucis2=cell(1,nm_names-1);
sigmas2 =cell(1,2);
for t = 1:2
    [mu, sigma, muci, ~]= normfit(squeeze(ratios_f(:,:,t)), 0.05);
    mus2{t} = mu;
    mucis2{t} = muci;
    sigmas2{t} = sigma;
end

x = 1:max_iter;
%
for t = 1:2
    %     plot(out_fs(:,t), plot_opt{t},'linewidth',0.4,'markersize', 0.5);
    %     errorbar(x, mus{t}, mucis{t}(1,:),mucis{t}(2,:), plot_opt{t},'linewidth',0.4,'markersize', 0.5);
    errorbar(x, mus2{t}, sigmas2{t}, plot_opt{t+1},'linewidth',0.3,'markersize', 0.4)
    hold on;
end
% t = solver_list(end);
%     plot(out_fs(:, t), plot_opt{t},'color', [0 0.3 0],'linewidth',3);
hold off;

legend(solver_names{2:3}, ...
    'Location','best');
set(gca,'fontsize',6)
% set(gca, 'FontName', 'Times');
axis([1 max_iter -inf inf])
xlabel('K');
ylabel('Objective/OPT');
fig_name = [out_dir data_name{data_id} subfix '_ratio'];
saveas(hFig, fig_name, 'pdf');
