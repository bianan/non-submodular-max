function cur_pm = calc_cur_pm(f, pm, xs_fr, fs_fr, x_tra_fr, max_k)
% cur:  classical total curvature: \alpha^total
% cur_g:  greedy curvature: alpha^G

n = pm.n;
max_k = n;
rhos = zeros(n,1);
rhos(1) = fs_fr(1);
for i = 2:n
    rhos(i) = fs_fr(i) - fs_fr(i-1);
end
% calc total curvature
rho_j = zeros(n,1);
rho_jE = zeros(n,1);
rho_ratio2 = zeros(n,1);
v = ones(n,1); % ground set
fE = f(v,pm);
tmp=zeros(n,1);
for i = 1:n
    tmpi = tmp;
    tmpi(i) = 1;
    rho_j(i) = f(tmpi,pm);
    tmpi2 = v;
    timpi2(i) = 0;
    rho_jE(i) = fE - f(tmpi2,pm);
    
    if rho_j(i) > 0 && rho_jE(i) > 0
        rho_ratio2(i) = rho_jE(i)/ rho_j(i);
    end
end

min_rho = min(rho_ratio2);
cur_pm.cur = 1 - min_rho;

%  calc alpha^G

cur_min = ones(max_k, 1);   %  the min in the greedy curvature def.

for k = 2:max_k;
    min_rho_ratio = Inf;
    
    sk_1 = xs_fr(:,k-1);  %   nx1, S^k-1
    % enumerate Omega   size of k
    nz_ids_v = find(1==v)';
    omegas = nchoosek(nz_ids_v, k);
    nm_omegas = size(omegas, 1);
    
    for id_omega = 1:nm_omegas
        omega_ids = omegas(id_omega, :)';
        omega = zeros(n,1);
        omega(omega_ids) = 1;
        minus_set = sk_1 - omega;
        nz_ids_minus_set = find(1==minus_set)';
        nz_nm = length(nz_ids_minus_set);
        
        rho_ratio = 1;
        if 0 == nz_nm
            rho_ratio = 1;
        else
            for ji = 1:nz_nm;
                element_id = nz_ids_minus_set(ji);
                
                i = find(element_id == x_tra_fr);  %  should be the index of trajectory
                si_1 = zeros(n,1);
                if i >1;
                    si_1 = xs_fr(:,i-1);
                end
                union_set = si_1 + omega;
                f_union_set = f(union_set, pm);
                
                if rhos(i) > 0
                    tmp_union_set = union_set;
                    tmp_union_set(element_id) = 1;
                    rho_i_omega = f(tmp_union_set, pm) - f_union_set;
                    if rho_i_omega > 0
                        rho_ratio = rho_i_omega/rhos(i);
                    end
                end
            end
            
        end
        if rho_ratio < min_rho_ratio;
            min_rho_ratio = rho_ratio;
        end
    end
    cur_min(k) = min_rho_ratio;
end
cur_pm.cur_g = 1- cur_min;
end
