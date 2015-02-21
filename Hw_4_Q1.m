clear;
clc;
u1 = -2;
u2 = -3;
n = 2;
x = zeros(n,1);
y = zeros(n,1);
P = [1,-.5;-.5, 2];
q = [-1;0];
A = [1, 2; 1, -4; -1, -1];
delta = [0; -.1; .1];
m = length(delta);
RHS = [u1; u2; 5];

cvx_begin quiet
    variable y(n);
    dual variable lambda_zero;
    minimize(quad_form(y,P)+q'*y)
    subject to
        lambda_zero : A*y<=0;
cvx_end
p_star_zero=y'*P*y+q'*y
lambda_zero

for i=1:m
    for j=1:m
        perturb=[delta(i);delta(j);0];
        cvx_begin quiet
            variable x(n);
            dual variable lambda;
            minimize(quad_form(x,P)+q'*x)
        subject to
            lambda : A*x<=RHS+perturb;
        cvx_end
    delta_val=[delta(i),delta(j)]
    x
    lambda
    p_star=x'*P*x+q'*x
    p_star_pred = p_star_zero - lambda'*(RHS+perturb)
    p_star_gap = p_star-p_star_pred
    KKT_cond1 = 2*P*x+q+A'*lambda
    KKT_cond2 = lambda'*(A*x-(RHS+perturb))
    end
end



%KKT_cond1 = 2*P*x+q+A'*lambda
%KKT_cond2 = lambda'*(A*x-RHS)