%% simple_portfolio_data
n=20;
rand('state',5);
% rng(5,'v5uniform');
pbar = ones(n,1)*.03+[rand(n-1,1); 0]*.12;
randn('state',5);
%rng(5,'v5normal');
S = randn(n,n);
S = S'*S;
S = S/max(abs(diag(S)))*.2;
S(:,n) = zeros(n,1);
S(n,:) = zeros(n,1)';
x_unif = ones(n,1)/n;


x1 = zeros(n,1);
x2 = zeros(n,1);
x3 = zeros(n,1);
x4 = zeros(n,1);

cvx_begin
    variable x2(n)
    minimize(x2'*S*x2)
    subject to
        pbar'*x2==pbar'*x_unif;
        ones(n,1)'*x2==1;
cvx_end

cvx_begin
    variable x3(n)
    minimize(x3'*S*x3)
    subject to
        pbar'*x3==pbar'*x_unif;
        ones(n,1)'*x3==1;
        x3>=0;
cvx_end

cvx_begin
    variable x4(n)
    minimize(x4'*S*x4)
    subject to
        pbar'*x4==pbar'*x_unif;
        ones(n,1)'*x4==1;
        ones(n,1)'*max(-x4,0)<=0.5;
cvx_end

risk1 = sqrt(x_unif'*S*x_unif)
risk2 = sqrt(x2'*S*x2)
risk3 = sqrt(x3'*S*x3)
risk4 = sqrt(x4'*S*x4)
