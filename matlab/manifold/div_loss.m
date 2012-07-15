function d = div_loss(theta1,theta2,xcrit,loss)
    mu1 = theta1(1);
    mu2 = theta2(1);
    s1 = theta1(2);
    s2 = theta2(2);
    
    p1 = 1-normpdf(xcrit,mu1,s1);
    p2 = 1-normpdf(xcrit,mu2,s2);
    
    p1*l - 1
    p2*l - 1
    
   