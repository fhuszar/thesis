function draw_comparison_chart(X)
[K,N] = size(X);
clf;
hold on;

for n=1:N-1
   fill([X(:,n)',flipud(X(:,n+1))'],[1:K,K:-1:1],X(1,n),'FaceAlpha',0.4,'EdgeAlpha',0.05)
end

for k=1:K
    plot(X(k,:),k*ones(1,N),'k.');
end
hold off;
