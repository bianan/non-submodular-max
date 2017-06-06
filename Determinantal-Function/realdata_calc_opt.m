close all;
clear all;
%

data_id = 1;
nm_exps = 1; % # repeated experiments, for real data, it is set as 1
% 1:
data_name={'CIFAR10', 'Synthetic'}; %
f = @det_fn;


for exp_id = 1:nm_exps
    
    pm(exp_id) = load_data4opt(data_id);
    
end

%%
out_dir = 'out_real/';
if ~ mkdir(out_dir)
    disp('cannot create the output directory!');
end

subfix = pm(1).subfix;
file_name = [out_dir 'data_' data_name{data_id}  '_' subfix];
save(file_name, 'pm');



