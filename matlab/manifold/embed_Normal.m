% setting parameters

params.n1 = 15;
params.n2 = 15;
params.min_theta1 = 1;
params.max_theta1 = 2;
params.min_theta2 = 0.1;
params.max_theta2 = 1;

div = @div_KL;
[X,thetas,parallel_edges] = embed_manifold(params,div);

draw_results(X,thetas,parallel_edges)
