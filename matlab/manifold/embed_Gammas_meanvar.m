% setting parameters
figure(1)
clf

params.n1 = 15;
params.n2 = 15;
params.min_theta1 = 1;
params.max_theta1 = 2;
params.min_theta2 = 0.1;
params.max_theta2 = 1;

div = @div_KL_Gamma_meanvar;
%div = @div_KL_Normal;
[X,thetas,parallel_edges] = embed_manifold(params,div);

draw_results(X,thetas,parallel_edges)
text(X(1,1)+0.1,X(1,2)+0.1,'(1,0.1)','HorizontalAlignment','left')
text(X(end-params.n2+1,1)-0.1,X(end-params.n2+1,2)+0.1,'(2,0.1)','HorizontalAlignment','right')
text(X(params.n1,1)+0.2,X(params.n1,2),'(1,1)','HorizontalAlignment','left')
text(X(end,1)+0.2,X(end,2),'(2,1)','HorizontalAlignment','left')
colorbar