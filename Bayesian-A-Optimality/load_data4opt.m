function pm = load_data4opt(data_id)
%% load data for calculing the optimal solution

switch data_id
    
    case 1, %   BostonHousing
        load housing.mat;
        housing = housing';
        d = 14;
        m = 506;  % orignal #samples
        n = 14; % used samples
        pm.subfix = 'd14n14';  % indicate that d = 14, n = 14
        X = housing(1:d, 1:n);
        
        for i = 1:n
            X(:,i) =  X(:,i)/norm(X(:,i));
        end
        
        pm.n = n;
        pm.m = m;
        pm.d = d;
        pm.X = X;
        Lambda = eye(d); % set beta = 1
        sigma = 1;
        pm.Lambda = Lambda;
        pm.sigma = sigma;
        pm.trace_Sigma_theta = trace(inv(Lambda));
        
        f = @a_optimality_fn;
        [opt_fs, opt_xs] = exhaustive_search(f, pm);
        %  opt_fs:   nx1
        %  opt_xs:  nxn
        
        pm.opt_fs = opt_fs;
        pm.opt_xs = opt_xs;
        
    case 2,% synthetic
        
        d = 6;
        n = 12;
        correlation = 0.6;
        pm.subfix = 'd6n12c6';  %
        
        mu = zeros(d,1);
        Sigma = correlation*ones(d,d);
        for i = 1:d
            Sigma(i,i) = 1;
        end
        
        X = [];
        
        for i = 1:n
            x = mvnrnd(mu, Sigma);
            x = x/norm(x);
            X = [X x'];
        end
        
        Lambda = eye(d);
        sigma = 1;
        
        pm.n = n;
        pm.d = d;
        pm.X = X;
        pm.Lambda = Lambda;
        pm.sigma = sigma;
        pm.correlation = correlation;
        pm.trace_Sigma_theta = trace(inv(Lambda));
        
        
        f = @a_optimality_fn;
        [opt_fs, opt_xs] = exhaustive_search(f, pm);
        %  opt_fs:   nx1
        %  opt_xs:  nxn
        
        pm.opt_fs = opt_fs;
        pm.opt_xs = opt_xs;
        
end
end
