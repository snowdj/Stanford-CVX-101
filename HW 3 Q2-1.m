variable x1, x2
cvx_begin
    minimize x1+x2;
    subject to
        2*x1+x2 >=1;
        x1+3*x2>=1;
        x1>=0;
        x2>=0;
 cvx_end