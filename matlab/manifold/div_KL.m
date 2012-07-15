function d = div_KL(theta1,theta2)
    mu1 = theta1(1);
    mu2 = theta2(1);
    s1 = theta1(2);
    s2 = theta2(2);
    
    logratio = 2 * (log(s1)-log(s2));
    d = (mu1 - mu2)^2/2/s2^2 + 0.5*(exp(logratio) - 1 - logratio);