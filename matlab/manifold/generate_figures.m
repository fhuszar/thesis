% this script generates figures for inclusion in LaTeX
addpath ../matlab2tikz_0.2.2/src/
addpath ../compiletikz

basedir = 'figs/';
% Bernoulli random variables
embed_Bernoulli
%saving figures
savefigure([basedir,'Bernoulli_comparison.tikz'],1,0.5);
savefigure([basedir,'Bernoulli_magnification.tikz'],2,0.5)

% Normals, embedding by varince only
embed_Normals_varonly
% saving figures
savefigure([basedir,'Normal_varonly_comparison.tikz'],1,1)
% TODO: fixing y tick labels
% system(['cat ',basedir,'Normal_varonly_comparison.tikz | sed A,B,C,D')
% {kernel, \(\ell=0.1\)},{kernel, \(\ell=0.2\)}, {kernel,\(\ell=0.5\)},{kernel, \(\ell=1.0\)}
savefigure([basedir,'Normal_varonly_magnification.tikz'],2,0.6)

% Normals, Shannon information geometry
embed_Normals_KL
savefigure([basedir,'Normal_meanvar.tikz'],1,0.8);

% Normals, quadratic and spherical kernel
embed_Normal_kernel
for i=1:8
    savefigure([basedir,'Normal_kernel_', int2str(i),'.tikz'],i,0.8);
end
% Gammas, Shannon information geometry, by mean and variance
embed_Gammas_meanvar
xlim([-24,17])
ylim([-14,7.5])
savefigure([basedir,'Gamma_meanvar.tikz'],1,0.8);

tikzfiles = dir([basedir '*.tikz']);
for i = 1:size(tikzfiles,1)
    compiletikz([basedir,tikzfiles(i).name])
end
