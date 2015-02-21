clear;
clc;

b=[1;2;5;8;4;3;3];
one=ones(length(b),1);
cvx_begin
    variable x;
    minimize(norm(x*one-b,Inf));
cvx_end
x