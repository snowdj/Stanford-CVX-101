rand('state',0);
n=100;
m=300;
A=rand(m,n);
b=A*ones(n,1)/2;
c=-rand(n,1);
t = linspace(0,1,1000);
cvx_begin
    variable x(n);
    minimize (c' * x);
    subject to
        A * x <= b;
        zeros(n,1) <= 1 <= ones(n,1);
 cvx_end
 L=c'*x
 lt = length(t);
 lx = length(x);
 x_hat = zeros(lx,lt);
 U = zeros(lt,1);
 A_x_hat = zeros(lx,lt);
 Cons_Viol = zeros(lx,lt);
 Max_Cons_Viol = zeros(lt,1);
 for i=1:lt
    for j=1:lx
        if x(j)>=t(i)
            x_hat(j,i)=1;
        else
            x_hat(j,i)=0;
        end
    end
    U(i)=c'*x_hat(:,i);
 end
 A_x_hat=A*x_hat;
 for i=1:lt
     for j=1:lx
        Cons_Viol(j,i)=A_x_hat(j,i)-b(j);
     end
 end
 for i=1:lt
     Max_Cons_Viol(i)=max(Cons_Viol(:,i));
 end
 U2=min(U(find(Max_Cons_Viol<=0)));
 gap = U-L;
 plot(t,U,'r:o');
 hold on;
 plot(t,Max_Cons_Viol,'b-*');
 xlabel('t');
 legend('U','Max Constaint Violation');