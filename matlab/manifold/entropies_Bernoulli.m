N = 300;
ps = linspace(0,1,N);

figure(1)
clf
hold on

plot(ps,.5*entropy_Shannon_Bernoulli(ps)/max(entropy_Shannon_Bernoulli(ps)),'b')
plot(ps,.5*entropy_Brier_Bernoulli(ps)/max(entropy_Brier_Bernoulli(ps)),'k')
plot(ps,.5*entropy_spherical_Bernoulli(ps)/max(entropy_spherical_Bernoulli(ps)),'r')