function H = entropy_Brier_Bernoulli(theta)
    p=[theta;1-theta];
    H = 1 - sum(p.*p);