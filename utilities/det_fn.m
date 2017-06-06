function f = det_fn(x, pm)
% x: nx1;  {0, 1}^n
% f = det(I + sigma^(-2)* L(x)) 

nm_nnz = sum(x);
if 0 == nm_nnz;
    f = 0;
else
    sigma = pm.sigma;
    L = pm.L;
    nnz_idx = find(1==x)';
    f = det(eye(nm_nnz) + sigma^(-2)*L(nnz_idx, nnz_idx));
end

end
