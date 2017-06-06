close all;
clear all;

data_id = 1;
data_name={'BostonHousing', 'Synthetic'}; %
pm = load_data4opt(data_id);

%%
subfix = pm.subfix;

out_dir = 'out_realdata/';
if ~ mkdir(out_dir)
    disp('cannot create the output directory!');
end

file_name = [out_dir 'data_' data_name{data_id}  '_' subfix];
save(file_name, 'pm');



