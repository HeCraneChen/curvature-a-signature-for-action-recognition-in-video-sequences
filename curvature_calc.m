%Crane Chen hchen136@jhu.edu
%This is a curvature calculation function
%Curvature and tortion are calculated, (namely, the first order and second
%order curvatures are calculated)
function [K1,K2]=curvature_calc(c,F,X1_opt)
    K_pre=zeros(1,101);
    K1=zeros(1,101);
    A = df_array(2,c*F,X1_opt,2,2);
    K1=sqrt(sum(A.^2));
    e2 = A./K1;
    
    e1 = df_array(1, F*c, X1_opt, 2, 2);
    e3 = df_array(1, F*c, e2, 2, 2) + e1.*K1;
    K2=sqrt(sum(e3.^2));
    e3=e3./K2;
    
end
