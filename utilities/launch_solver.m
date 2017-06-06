function [xs, fs, x_tra,  runtime] = ...
    launch_solver(f, pm, method, max_iter)
% launch solvers 
n = pm.n;
switch method
    
    case 1, % OPT
        opt_fs = pm.opt_fs;
        fs = opt_fs(1:max_iter);
        xs = pm.opt_xs;
        x_tra = zeros(n, 1);  %  no trajectory for optimal solution
        runtime = 0;
        
    case 2, % greedy
        [xs, fs, x_tra,  runtime] ...
            = greedy(f, pm, max_iter);
    case 3, % sdp
        [xs, fs, x_tra, runtime] ...
            = sdp(f, pm,max_iter);
        
end

end
