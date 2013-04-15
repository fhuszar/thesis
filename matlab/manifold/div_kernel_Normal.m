function d = div_kernel_Normal(theta1,theta2,ell)
    mu1 = theta1(1);
    mu2 = theta2(1);
    s1 = theta1(2);
    s2 = theta2(2);
    
    sqnormp = 1/sqrt(ell^2+2*s1^2);
    sqnormq = 1/sqrt(ell^2+2*s2^2);
    scalarpq = 1/sqrt(ell^2+s1^2+s2^2)*exp(-(mu1 - mu2)^2/2/(ell^2+s1^2+s2^2));
    d = sqnormp + sqnormq - 2*scalarpq;