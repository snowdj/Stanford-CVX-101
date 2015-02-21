clear;
clc;

ls = 200;
S = linspace(.5, 2,ls);
S0 = 1;
lp = 6;
K = [1.1; 1.2; 0.8; 0.7];
C = 1.15;
F = 0.9;
r = 1.05;
r_vec=r*ones(ls,1)';
V = zeros(lp,ls);
V(1,:) = r_vec;
V(2,:) = max(0,S-K(1));
V(3,:) = max(0,S-K(2));
V(4,:) = max(0,K(3)-S);
V(5,:) = max(0,K(4)-S);
for i=1:ls
    if S(i)>C
        V_temp = C-S0;
    elseif (F<=S(i) && S(i)<=C)
        V_temp= S(i)-S0;
    elseif  S(i)<=F
        V_temp = F-S0;
    end
%     V(6,i) = max(0,V_temp);
    V(6,i) = V_temp;
end

y = zeros(ls,1);

%for i=1:ls
    cvx_begin
        variables y(ls) pc;
        minimize(pc);
    subject to
        V*y == [1; 0.06; 0.03; 0.02; 0.01; pc];
        y >= 0;
    cvx_end
%end
