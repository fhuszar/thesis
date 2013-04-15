function H = entropy_spherical_Normal(sigmas)
    sqnormp = 1./sqrt(2*sigmas.^2);
    H = - sqrt(sqnormp);