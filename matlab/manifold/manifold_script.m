%% target mixture

%% initialisation
resolution = 20;
m = linspace(-1,1,resolution)';
s = logspace(-5,2,resolution)';
m = repmat(m,[resolution,1]);
s = repmat(s,[1,resolution])';
s = s(:);
m = [m;0];
s = [s;0];

%% setting up p
s1 = 0.1;
s2 = 0.02;
m1 = 0;
m2 = -0.5;
p = 0.2;

a1 = m1^2 + s1^2;
a2 = m2^2 + s2^2;
mstar = p*m1 + (1-p)*m2;
sstar = sqrt(p*a1 + (1-p)*a2 - mstar^2);

m(end) = mstar;
s(end)=sstar;

% this is incorrect? no, the entropy of p is constant, so this should work
dist_from_p  = p*(s1./s + (m1 - m).^2./s - log(s1) + log(s) - 1)/2+...
    (1-p)*(s2./s + (m2 - m).^2./s - log(s2) + log(s) - 1)/2;


%% adding optimum to the samples


D = bsxfun(@rdivide,s,s') + bsxfun(@rdivide,bsxfun(@minus,m,m').^2,s') - 1;

%computing symmetrised KL divergence
D = (D + D')/4;
% 2D embedding
%y = mdscale(D,2);
%scatter(y(:,1),y(:,2),100*(4.5+log10(s)),m,'.');

%% 3D embedding

% here, we have to compute nearest neighbours and shortest paths, for a
% useful embedding
% NO! conpute only a grid of distances and then auto-complete it using
% Dijkstra...
y = mdscale(sqrt(D),3,'start','random','replicates',2);
ystar = y(end,:);
y(end,:) = [];


%% plotting 3D embedding
hold off;
surf(reshape(y(:,1),resolution,resolution),reshape(y(:,2),resolution,resolution),reshape(y(:,3),resolution,resolution),reshape(log(dist_from_p(1:end-1)),resolution,resolution),...
    'FaceLighting','phong',...
    'FaceColor','interp',...
    'EdgeAlpha',0.5,...
    'FaceAlpha',0.7);
hold on;
plot3(ystar(1),ystar(2),ystar(3),'r.');
hold off;
view(-45,30);
axis tight;
axis off;
colormap jet