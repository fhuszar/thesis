function d = div_KL(theta1,theta2,ell)
    mu1 = theta1(1);
    mu2 = theta2(1);
    s1 = theta1(2);
    s2 = theta2(2);
    
    d = ell*(1/(ell+2*s1) + 1/(ell+2*s2) - 2/(ell+s1+s2)*exp(-(mu1 - mu2)^2/2/(ell+s1+s2)^2));