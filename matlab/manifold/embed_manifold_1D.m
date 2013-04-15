function [X,theta] = embed_manifold_1D(params,divergence,logarithmic)

if nargin<3
    logarithmic = false;
end
if logarithmic
    theta = logspace(log10(params.min_theta),log10(params.max_theta),params.n);
else
    theta = linspace(params.min_theta,params.max_theta,params.n);
end

D = Inf(params.n);
distance = @(x,y) sqrt(divergence(x,y) + divergence(y,x)); % approximation only valid for small distances

% drawing edges between neighbouring theta1 values but same theta2 values
for i=1:params.n-1
    D(i,i+1) = distance(theta(i),theta(i+1));
end

D = min(D,D');
% setting diagonals to zero
for i=1:params.n
    D(i,i)=0;
end

%computing shortest paths

P = D;

for k=1:params.n
    for i = 1:params.n
        for j = 1:params.n
            P(i,j) = min(P(i,j),P(i,k)+P(k,j));
        end
    end
end


X = mdscale(P,1);