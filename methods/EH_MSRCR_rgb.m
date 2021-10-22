function output = EH_MSRCR_rgb(Ir,Ig,Ib,Rr,conf)
%% -----------
G = conf.MSR_G;
b = conf.MSR_b;
alpha = conf.MSR_alpha;
beta = conf.MSR_beta;

%º∆À„CR 
CRr = beta*(log(alpha*Ir+1)-log(Ir+Ig+Ib+1)); 
Rr = G*(CRr.*Rr+b); 
min1 = min(min(Rr)); 
max1 = max(max(Rr)); 
output = uint8(255*(Rr-min1)/(max1-min1)); 
