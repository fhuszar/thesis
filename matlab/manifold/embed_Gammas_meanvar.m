% setting parameters
params.n1 = 20;
params.n2 = 20;
params.min_theta1 = 1;
params.max_theta1 = 2;
params.min_theta2 = 0.1;
params.max_theta2 = 1;

div = @div_KL_Gamma_meanvar;
%div = @div_KL;
[X,thetas,parallel_edges] = embed_manifold(params,div);

draw_results(X,thetas,parallel_edges)
