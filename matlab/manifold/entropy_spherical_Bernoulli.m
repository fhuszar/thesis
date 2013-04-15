function H = entropy_spherical_Bernoulli(theta)
    p=[theta;1-theta];
    H = 1 - sqrt(sum(p.*p));