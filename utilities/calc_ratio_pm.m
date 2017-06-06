function ratio_pm = calc_ratio_pm(f, pm, xs_greedy, fs_greedy, max_k)
% calculate greedy submodularity ratio: \gamma^G
n = pm.n;
gammaG = zeros(max_k, 1);
gammaG(1) =1;

gammaK = zeros(max_k, 1);  % not calculated so far, too time consuming. It is not used either
gammaK(1) =1;

v = ones(n,1); % ground set
gammaG_tmp = Inf*ones(max_k, max_k); %  to observe, each column for outer loop
for k = 2:max_k;
    omegas = nchoosek(1:n, k);  % all possible omegas
    nm_omegas = size(omegas, 1);
    for t = 0:k-1;  %  all S^t
        if 0 == t
            tmp = Inf;
            for i = 1:nm_omegas   % enumerate all omegas
                omega = zeros(n,1);
                omega(omegas(i, :)) = 1;
                
                rho_omega = f(omega, pm);
                
                if 0 == rho_omega
                    tmp =1;
                else
                    rho_sum = 0;
                    
                    for j = 1:k
                        omega1 = zeros(n,1);
                        omega1(omegas(i, j)) = 1;
                        rho_sum = rho_sum + f(omega1, pm);
                    end
                    tmp = rho_sum/rho_omega;
                end
                if gammaG_tmp(1+t, k) > tmp
                    gammaG_tmp(1+t, k) = tmp;
                end
            end
            
        else %  t>0   S^t
            st = xs_greedy(:, t);
            fst = fs_greedy(t);
            tmp = Inf;
            for i = 1:nm_omegas   % enumerate all omegas
                omega = zeros(n,1);
                omega(omegas(i, :)) = 1;
                
                omega_st = omega + st;%  omega union st
                omega_st(2==omega_st) = 1;
                
                rho_omega = f(omega_st, pm) - fst;
                
                if 0 == rho_omega
                    tmp = 1;
                else
                    
                    rho_sum = 0;
                    omega_minus_st_tmp = omega - st;
                    omega_minus_st = zeros(n,1);
                    nz = find(1 == omega_minus_st_tmp)';
                    omega_minus_st(nz) = 1;
                    
                    nnz_omega_minus_st = sum(omega_minus_st);
                    
                    for j = 1:nnz_omega_minus_st
                        omega1 = zeros(n,1);
                        omega1(nz(j)) = 1;
                        omega1_st = omega1+st;
                        rho_sum = rho_sum + f(omega1_st, pm);
                    end
                    tmp = (rho_sum - nnz_omega_minus_st*fst)/rho_omega;
                end
                if gammaG_tmp(1+t, k) > tmp
                    gammaG_tmp(1+t, k) = tmp;
                end
            end
        end
    end
    gammaG(k) = min(gammaG_tmp(:,k));
end
gammaG = max(gammaG, 0); % only invoked for LP experiments sometime. Due to
% the precision of LP solvers, gamma could be slightly negative in very rare cases.

ratio_pm.gammaG = gammaG;
ratio_pm.gammaK = gammaK;
end
