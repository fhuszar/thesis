params.n = 53;
params.min_theta = 1e-3;
params.max_theta = 1-1e-3;
figure(1)
clf
hold on;

divergence = @div_Brier_Bernoulli;
[X,thetas] = embed_manifold_1D(params,divergence);
%normalise X
X_Brier = (X - min(X))/(max(X)-min(X));

divergence = @div_spherical_Bernoulli;
[X,thetas] = embed_manifold_1D(params,divergence);
%normalise X
X_spherical = (X - min(X))/(max(X)-min(X));

divergence = @div_KL_Bernoulli;
[X,thetas] = embed_manifold_1D(params,divergence);
%normalise X
X_KL = (X - min(X))/(max(X)-min(X));



figure(1)

X=zeros(4,params.n);
X(1,:) = X_Brier;
X(2,:) = X_spherical;
X(3,:) = X_KL;
X(end,:) = X_Brier;
draw_comparison_chart(X)
set(gca,'YTick',1:4);
set(gca,'YTickLabel',{'Brier','spherical','KL','Brier'});
set(gca, 'XTick', [0,0.5,1]);

figure(2)
clf
hold on;
t = (thetas(1:end-1) + thetas(2:end))/2;
plot(t,bsxfun(@rdivide,diff(X(1,:)'),diff(X(1,:)')),':k','LineWidth',1.5)
plot(t,bsxfun(@rdivide,diff(X([2,3],:)'),diff(X(1,:)')),'LineWidth',1.5)
legend({'Brier','spherical','KL'},'Location','North');
set(gca,'XTick',[0,0.5,1])
figure(1)