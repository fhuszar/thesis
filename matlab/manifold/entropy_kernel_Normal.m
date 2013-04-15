function H = entropy_kernel_Normal(sigmas,ell)
    sqnormp = ell./sqrt(ell^2+2*sigmas.^2);
    H = 1 - sqnormp;