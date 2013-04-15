function H = entropy_Brier_Normal(sigmas)
    sqnormp = 1./sqrt(2*sigmas.^2);
    H = - sqnormp;