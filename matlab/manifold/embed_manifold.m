function [X,theta,parallel_edges] = embed_manifold(params,divergence)

theta1 = linspace(params.min_theta1,params.max_theta1,params.n1);
theta2 = linspace(params.min_theta2,params.max_theta2,params.n2);
theta = [reshape(repmat(theta1,[params.n2,1]),[params.n1*params.n2,1]),repmat(theta2',[params.n1,1])];

D = Inf(params.n1*params.n2);

parallel_edges = false(params.n1*params.n2);

% drawing edges between neighbouring theta1 values but same theta2 values
for i=1:params.n1-1
    for j=1:params.n2
        index1 = (i-1)*params.n2 + j;
        index2 = i*params.n2 + j;
        D(index1,index2) = (divergence(theta(index1,:),theta(index2,:)) + divergence(theta(index2,:),theta(index1,:)))/2;
        parallel_edges(index1,index2) = true;
    end
end

%drawing edges between neighbouring theta1 values but same theta2 values
for i=1:params.n1
    for j=1:params.n2-1
        index1 = (i-1)*params.n2 + j;
        index2 = (i-1)*params.n2 + j + 1;
        D(index1,index2) = (divergence(theta(index1,:),theta(index2,:)) + divergence(theta(index2,:),theta(index1,:)))/2;
        parallel_edges(index1,index2) = true;
    end
end

% drawing diagonal edges of one kind
for i=1:params.n1-1
    for j=1:params.n2-1
        index1 = (i-1)*params.n2 + j;
        index2 = i*params.n2 + j + 1;
        D(index1,index2) = (divergence(theta(index1,:),theta(index2,:)) + divergence(theta(index2,:),theta(index1,:)))/2;
    end
end

% drawing diagonal edges of the other kind
for i=1:params.n1-1
    for j=1:params.n2-1
        index1 = (i-1)*params.n2 + j + 1;
        index2 = i*params.n2 + j;
        D(index1,index2) = (divergence(theta(index1,:),theta(index2,:)) + divergence(theta(index2,:),theta(index1,:)))/2;
    end
end

N = params.n1*params.n2;
D = min(D,D');
% setting diagonals to zero
for i=1:N
    D(i,i)=0;
end

%computing shortest paths

P = D;

for k=1:N
    for i = 1:N
        for j = 1:N
            P(i,j) = min(P(i,j),P(i,k)+P(k,j));
        end
    end
end


X = mdscale(P,2);