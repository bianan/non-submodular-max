close all;
clear all;
%
data_id = 2;
nm_exps = 20; % # repeated experiments
% 1:
data_name={'@notUsed', 'Synthetic'}; %
f = @lp_fn;

for exp_id = 1:nm_exps
    
    pm(exp_id) = load_data4opt(data_id);
    
end
%%
out_dir = 'out_syn/';
if ~ mkdir(out_dir)
    disp('cannot create the output directory!');
end

subfix = pm.subfix;

file_name = [out_dir 'data_' data_name{data_id}  '_' subfix];
save(file_name, 'pm');



