function d = div_sperical_Bernoulli(theta1,theta2)
    p = [theta1;1-theta1];
    q = [theta2;1-theta2];
    d = norm(p) - p'*q/norm(q);