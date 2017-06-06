function f = a_optimality_fn(x, pm)
% x: nx1;  {0, 1}^n
X = pm.X;
nm_nnz = sum(x);
if 0 == nm_nnz;
    f = 0;
else
    sigma = pm.sigma;
    Lambda = pm.Lambda;
    nnz_idx = find(1==x)';
    XS = X(:,nnz_idx);
    f = pm.trace_Sigma_theta - trace(inv(Lambda + sigma^(-2)*XS*XS'));
end

end
