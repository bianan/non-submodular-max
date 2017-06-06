function [xs, fs, x_tra,  run_time] ...
    = sdp(f, pm, max_iter)
% the SDP algorithm
n = pm.n;
d = pm.d;
X = pm.X;  %  d,
Lambda=pm.Lambda;
sigma = pm.sigma;

xs = zeros(n,n);
fs = [];
tic;
% SDP formulation for invoking CVX
e = eye(d,d);
cvx_begin sdp
variables lambda(n) u(d)
minimize ( sum(u) )
subject to
for k = 1:d
    [ Lambda+(X*diag(lambda)*X')/(sigma^(2))  e(:,k);
        e(k,:)                                 u(k)   ] >= 0;
end
sum(lambda) == 1;
lambda >= 0;
cvx_end

lambdaA = lambda;
[~, x_tra] = sort(lambdaA, 1, 'descend');
run_time = toc;

for i = 1:n
    xs(x_tra(i), i:n) = 1;
end

for i =1:n
    fs = [fs f(xs(:,i),pm)];
end

end
