function H = entropy_Shannon_Normal(sigmas)

    H = 0.5 + 0.5*log(2*pi*sigmas);
    