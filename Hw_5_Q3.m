clear;
clc;

k=201;
t = linspace(-3,3,k)';
y = exp(t);

M = vander(t);
M = M(:,k-2:k);

g = @(a,x)(polyval([a(3) a(2) a(1)],x));
h = @(b,x)(polyval([b(2) b(1) 1],x));

cvx_precision(.001);

cvx_begin sdp
    variables a(3) b(2) q;
    minimize(q);
    subject to
        diag(M*a).*inv_pos(M*[b;1]) <= q*ones(k,1) + y;
        diag(M*a).*inv_pos(M*[b;1]) + q*ones(k,1) >= y;
cvx_end
strcmp(cvx_status,'Solved')
a0
a1
a2
b1
b2
