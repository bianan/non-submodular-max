function [xs, fs, x_tra,  run_time] ...
    = greedy(f, pm, max_iter)
% max_iter:  used as n
n = pm.n;
x_tra = zeros(n, 1);
xs = zeros(n,n);
x = zeros(n, 1);
fs_greedy = [f(x, pm)];
gain = -Inf(n,1);
tic;
for i = 1:max_iter
    fold = fs_greedy(end);
    zero_id = find(0==x)';
    max_gain = -Inf;
    max_id = 0;
    for j = zero_id
        x_tmp = x;
        x_tmp(j) = 1;
        gain(j) = f(x_tmp, pm) - fold;
        if gain(j) > max_gain;
            max_gain = gain(j);
            max_id = j;
        end
    end
    x(max_id) = 1;
    x_tra(i) = max_id;
    fs_greedy = [fs_greedy fold+max_gain];
    xs(:,i) = x;
end
run_time = toc; 
fs = fs_greedy(2:end);
end
