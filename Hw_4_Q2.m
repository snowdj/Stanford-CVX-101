clear;
clc;

cvx_begin 
    variable x;
    dual variable lam;
    minimize(x^2+1)
    subject to
        lam : (x-2)*(x-4)<=0;
cvx_end
lam

t = linspace(1.9,4.1,1000);
lt = length(t);
f0 = @(t)(t.^2+1);
f1 = @(t)((t-2).*(t-4));
L = @(t,lambda)(f0(t)+lambda*f1(t));
g = @(lambda)(L(3*lambda/(1+lambda),lambda));

f0_plot=f0(t);
f1_plot=f1(t);
L1_plot=L(t,1);
L2_plot=L(t,3);
L3_plot=L(t,4);
g_plot=g(t);

plot(t,f0_plot,'-b','LineWidth',2);
hold on;
grid
plot(x,f0(x),'d');
hold on;
plot(t,f1_plot);
plot(t,L1_plot,'-.r');
plot(t,L2_plot,'--.g');
plot(t,L3_plot,'-k');
plot(t,g_plot,'-m');
hold off;