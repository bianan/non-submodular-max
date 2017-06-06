function [ pm] = load_data4opt(data_id);
%% load data for calculing the optimal solution


switch data_id
    
    
    case 1, %   cifar10 data
        
        f = @det_fn;
        
        cfar_file = 'cifar10n12';
        load (cfar_file); % load cfar similarity matrix L (already calculated)
        n = 12;
        sigma = 2;
        pm.subfix = 'cifar-n12sigma2';
        
        pm.n = n;
        pm.L = L;
        pm.sigma = sigma;

        [opt_fs, opt_xs] = exhaustive_search(f, pm);
        %  opt_fs:   nx1
        %  opt_xs:  nxn
        
        pm.opt_fs = opt_fs;
        pm.opt_xs = opt_xs;
        
    case 2,% Synthetic
        
        n = 10;
        sigma = 2;
        pm.subfix = 'syn-n10sigma2';
        B= RandOrthMat(n); % generate a random orthogonal matrix
        eigs= diag(rand(n, 1)*1);
        L= B'*eigs*B;
        pm.n = n;
        pm.L = L;
        pm.sigma = sigma;
        f = @det_fn;
        
        [opt_fs, opt_xs] = exhaustive_search(f, pm);
        %  opt_fs:   nx1
        %  opt_xs:  nxn
        
        pm.opt_fs = opt_fs;
        pm.opt_xs = opt_xs;
        
end

end
