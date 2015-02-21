clc;
clear;

% data file for flux balance analysis in systems biology
% From Segre, Zucker et al "From annotated genomes to metabolic flux
% models and kinetic parameter fitting" OMICS 7 (3), 301-316. 

% Stoichiometric matrix
S = [
%	M1	M2	M3	M4	M5	M6	
	1	0	0	0	0	0	%	R1:  extracellular -->  M1
	-1	1	0	0	0	0	%	R2:  M1 -->  M2
	-1	0	1	0	0	0	%	R3:  M1 -->  M3
	0	-1	0	2	-1	0	%	R4:  M2 + M5 --> 2 M4
	0	0	0	0	1	0	%	R5:  extracellular -->  M5
	0	-2	1	0	0	1	%	R6:  2 M2 -->  M3 + M6
	0	0	-1	1	0	0	%	R7:  M3 -->  M4
	0	0	0	0	0	-1	%	R8:  M6 --> extracellular
	0	0	0	-1	0	0	%	R9:  M4 --> cell biomass
	]';

[m,n] = size(S);
vmax = [
	10.10;	% R1:  extracellular -->  M1
	100;	% R2:  M1 -->  M2
	5.90;	% R3:  M1 -->  M3
	100;	% R4:  M2 + M5 --> 2 M4
	3.70;	% R5:  extracellular -->  M5
	100;	% R6:  2 M2 --> M3 + M6
	100;	% R7:  M3 -->  M4
	100;	% R8:  M6 -->  extracellular
	100;	% R9:  M4 -->  cell biomass
	];

v_pos = zeros(n,1);
v_neg = zeros(n,1);
lambda_pos = zeros(n,1);
lambda_neg = zeros(n,1);
v = zeros(n,1);

for j=1:n
    cvx_begin quiet
        variable vpos;
        dual variable lambdapos;
        sum = 0;
        minimize(vpos);
        subject to
            for i=1:m
                sum = sum + S(i,j)*vpos;
            end
            sum == 0;
            vpos >= 0;
            lambdapos : vpos <= vmax(j);
    cvx_end
    v_pos(j)=vpos;
    lambda_pos(j)=lambdapos;
end

for j=1:n
    cvx_begin quiet
        variable vneg;
        dual variable lambdaneg;
        sum = 0;
        minimize(-vneg);
        subject to
            for i=1:m
                sum = sum + S(i,j)*vneg;
            end
            sum == 0;
            vneg >= 0;
            lambdaneg : vneg <= vmax(j);
    cvx_end
    v_neg(j)=vneg;
    lambda_neg(j)=lambdaneg;
end

% cvx_begin
%     variables t v(n,1);
%     dual variable lam;
%     minimize t;
%     subject to
%         v <= t;
%         v >= -t;
%         S*v == 0;
%         v >= 0;
%         lam : v <= vmax;
% cvx_end


lambda_pos
lambda_neg
S*v_pos
S*v_neg
v_pos
v_neg
S

