function compiletikz(filename)

f = fopen('compiletikz_header','w');
fprintf(f,'\\documentclass[tikz]{standalone}\n');
fprintf(f,'\\usepackage{pgfplots}\n');
fprintf(f,'\\begin{document}\n');
fclose(f);


f = fopen('compiletikz_footer','w');
fprintf(f,'\n\\end{document}\n');
fclose(f);

command = ['cat compiletikz_header ' filename ' compiletikz_footer | /usr/texbin/pdflatex >/dev/null'];

disp(['Executing command >> ' command])
system(command);

command = ['mv texput.pdf ' filename(1:end-5) '.pdf'];

disp(['Executing command >> ' command])

system(command);