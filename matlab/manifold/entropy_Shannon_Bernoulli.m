function H = entropy_Brier_Bernoulli(theta)
    p=[theta;1-theta];
    plogp = p.*log2(p);
    plogp(isnan(plogp))=0;
    H = -sum(plogp);
    