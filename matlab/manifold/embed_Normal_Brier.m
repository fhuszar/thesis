% setting parameters

params.n1 = 15;
params.n2 = 15;
params.min_theta1 = 1;
params.max_theta1 = 3;
params.min_theta2 = 0.5;
params.max_theta2 = 2;

div = @(x,y) div_Brier_Normal(x,y);
ell = 0.2;
%div = @(x,y) div_kernel_Normal(x,y,ell);
[X,thetas,parallel_edges] = embed_manifold(params,div);
draw_results(X,thetas,parallel_edges)
