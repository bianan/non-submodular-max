function [opt_fs, opt_xs] = exhaustive_search(f, pm)
%  opt_fs:   nx1
%  opt_xs:  nxn
n = pm.n;
opt_fs = zeros(n,1);
opt_xs = zeros(n,n);
v = 1:n; % ground set
for k = 1:n
    max_f = -Inf;
    max_x = zeros(n,1);
    SS = nchoosek(v, k);    %    enumerate all subsets with k elements
    
    tmp = size(SS);
    nm_s = tmp(1);
    
    for j = 1:nm_s
        x = zeros(n,1);
        x(SS(j,:)) = 1;
        f_x = f(x, pm);
        if f_x > max_f;
            max_f = f_x;
            max_x = x;
        end
    end
    opt_fs(k) = max_f;
    opt_xs(:, k) = max_x;
    
end
end
