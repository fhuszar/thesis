function d = div_KL_Gamma(theta1,theta2)
    a1 = theta1(1);
    a2 = theta2(1);
    b1 = theta1(2);
    b2 = theta2(2);
    
    d = (a1 - a2)*psi(a1) -...
        gammaln(a1) + gammaln(a2)...
        + a2*(log(b1) - log(b2))...
        + a1*(b2 - b1)/b1;
    