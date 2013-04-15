function f = save_figure(X,thetas,parallel_edges,filename)

f = figure(1);
clf

hold on

[row,col] = find(parallel_edges);
for i=1:size(row,1)
    i1 = row(i);
    i2 = col(i);
    plot([X(i1,1),X(i2,1)],[X(i1,2),X(i2,2)],'k:');
end

scatter(X(:,1),X(:,2),70,thetas(:,2),'.'); 

axis equal

matlab2tikz(filename);
%post processing
system(['cat ', filename ,' | sed "s/draw=mapped color/draw=mapped color,fill=mapped color/g" >' filename '.tmp']);
system(['cat ' filename '.tmp > ' filename]);
delete([filename '.tmp']);
fhandle = fopen([filename,'.preview_header'],'w');
fprintf(fhandle,'\\documentclass{article}\n');
fprintf(fhandle,'\\usepackage{tikz}\n');
fprintf(fhandle,'\\usepackage{pgfplots}\n');
fprintf(fhandle,'\\usepackage[active,tightpage,pdftex]{preview}\n');
fprintf(fhandle,'\\begin{document}\n');
fprintf(fhandle,'\\begin{preview}\n');
fprintf(fhandle,'\\resizebox{\\columnwidth}{!}{\n');
fprintf(fhandle,'\n');
fclose(fhandle);
%copy contents of the file here
fhandle = fopen([filename,'.preview_footer'],'w');
fprintf(fhandle,'\n');
fprintf(fhandle,'}\n');
fprintf(fhandle,'\\end{preview}\n');
fprintf(fhandle,'\\end{document}\n');
fclose(fhandle);

system(['cat ' filename '.preview_header ' filename ' ' filename '.preview_footer > ' filename '.preview']);
