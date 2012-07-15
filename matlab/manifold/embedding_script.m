% setting parameters

params.n1 = 10;
params.n2 = 10;
params.min_theta1 = -1;
params.max_theta1 = 1;
params.min_theta2 = 0.2;
params.max_theta2 = 1;

n_lambdas = 10;
lambdas = logspace(-1.5,-0,n_lambdas);

X = cell(10,1);

for i=1:n_lambdas
    div = @(p,q) lambdas(i)*div_loss(p,q) + div_KL(p,q);
    [X{i},thetas,parallel_edges] = embed_manifold(params,div);
end

colors = jet(n_lambdas);
figure(1)
clf
hold on
[row,col] = find(parallel_edges);

N = size(X{1},1);
for i=1:n_lambdas-1
    for n=1:N
        plot([X{i}(n,1),X{i+1}(n,1)],[X{i}(n,2),X{i+1}(n,2)],'k:')
    end
end

for i=n_lambdas:-1:1
    plot(X{i}(:,1),X{i}(:,2),'.','Color',colors(i,:))
end

axis equal
