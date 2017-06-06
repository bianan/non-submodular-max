function [f, xlp] = lp_fn(s, pm)
% s: nx1;  {0, 1}^n
% output: x: nx1, [0,1]^n
n = pm.n;
% m = pm.m;
xlp = zeros(n,1);
nm_nnz = sum(s);
nnz_ids = find(s);
if 0 == nm_nnz;
    f = 0;
else
    As = pm.A(:,nnz_ids);
    ds = pm.d(nnz_ids);
    lbs = pm.lb(nnz_ids);
    ubs = pm.ub(nnz_ids);
    x0 = [];
    [x, f] = linprog(-ds, As, pm.b, [], [], lbs, ubs,x0, pm.opts);
    f = -f;
    xlp(nnz_ids) = x;
end
end
