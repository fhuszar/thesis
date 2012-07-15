% setting parameters

params.n1 = 20;
params.n2 = 20;
params.min_theta1 = 1;
params.max_theta1 = 3;
params.min_theta2 = 1;
params.max_theta2 = 3;

% choosing divergence function
div = @div_KL_Gamma;
[X,thetas,parallel_edges] = embed_manifold(params,div);

figure(1)
clf
hold on

[row,col] = find(parallel_edges);
for i=1:size(row,1)
    i1 = row(i);
    i2 = col(i);
    plot([X(i1,1),X(i2,1)],[X(i1,2),X(i2,2)],'k:');
end

plot(X(:,1),X(:,2),'.')

axis equal
