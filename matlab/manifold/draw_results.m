function f =  draw_results(X,thetas,parallel_edges)

hold on

[row,col] = find(parallel_edges);
for i=1:size(row,1)
    i1 = row(i);
    i2 = col(i);
    plot([X(i1,1),X(i2,1)],[X(i1,2),X(i2,2)],'k:');
end

scatter(X(:,1),X(:,2),70,thetas(:,2),'.')

axis equal
axis off