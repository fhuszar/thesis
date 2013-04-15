fh = fopen('output.tikz','w+');
fwrite(fh,clipboard('paste'));
fclose(fh);
system('/usr/texbin/pdflatex open_tikz_from_clipboard.tex');
system('open open_tikz_from_clipboard.pdf');