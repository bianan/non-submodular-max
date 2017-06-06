function [pm] = load_data4opt(data_id)
%% load data for calculing the optimal solution
switch data_id
    case 1, % not used
        f = @lp_fn;
        
    case 2,% Synthetic
        
        n = 6;
        m = 20; %  #linear constraints
        magn = 1;
        d = magn*ones(n, 1);  % each entry =1
        
        ub = ones(n, 1);
        lb = zeros(n, 1);
        baseA = 1;  %
        A = rand(m, n);  %
        b = 1*baseA*ones(m, 1);
        pm.subfix = 'n6m20';  %
        
        pm.m = m;
        pm.n = n;
        pm.A = A;
        pm.b = b;
        pm.d = d;
        pm.ub = ub;
        pm.lb = lb;
        pm.Aeq = []; pm.beq = [];
        pm.opts = optimoptions('linprog','Algorithm','interior-point',...
            'Display', 'off', 'MaxIterations', 200);
        f = @lp_fn;
        
        [opt_fs, opt_xs] = exhaustive_search(f, pm);
        %  opt_fs:   nx1
        %  opt_xs:  nxn
        
        pm.opt_fs = opt_fs;
        pm.opt_xs = opt_xs;
        
end
end
