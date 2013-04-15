function d = div_sphericalkernel_Normal(theta1,theta2,ell)
    mu1 = theta1(1);
    mu2 = theta2(1);
    s1 = theta1(2);
    s2 = theta2(2);
    
    normp1 = sqrt(1/sqrt(ell^2+2*s1^2));
    scalarp1p2 = 1/sqrt(ell^2+s1^2+s2^2)*exp(-(mu1 - mu2)^2/2/(ell^2+s1^2+s2^2));
    
    d = normp1 - scalarp1p2/normp1;