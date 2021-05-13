%% Header
%
%  Citation:
%   Johnson, J. E. and J. A. Berry. 2021. The role of Cytochrome b6f in the 
%	control of steady-state photosynthesis: a conceptual and quantitative 
%	model. Photosynthesis Research, DOI: 10.1007/s11120-021-00840-4
%
%  Description:
%   Example simulation with forward model and dynamic cross-sections
%
%  Compatibile with:
%   Matlab R2020b and Octave 6.2.0
%
%  Last revised: 
%   2021-04-25
%
%% Set up environment

% Clean up working environment
clear all; % variables
close all; % figures
clc; % command window

% Set up subdirectories
currdir = pwd;
workdir = fullfile(currdir,'/scripts');
resultsdir = fullfile(currdir,'/outputs');

% Get function from symbolic solver
cd(workdir)
symsolver_fun();

%% Select inputs

% Read in data file and create output directory
cd(resultsdir);
outputname = 'Example-2-dynamic';
mkdir(outputname);
cd(workdir);

% Specify environmental conditions
n = 2400;                                   % Steps in vector
data.Qin = transpose(linspace(1,2400,n));   % PAR, umol PPFD m-2 s-1
data.Tin = repmat(25,n,1);                  % Leaf temperature, C
data.Cin = repmat(200,n,1);                 % Mesophyll CO2, ubar
data.Oin = repmat(209,n,1);                 % Atmospheric O2, mbar

%% Configure model simulations

% Load default set of parameters
v = configure_fun(data);

% Adjust parameters of interest from default values
v.Abs = 0.85;           % Total leaf absorptance to PAR, mol mol-1
v.beta = 0.52;          % PSII fraction of total absorptance, mol mol-1
v.Ku2 = 2e09;           % Rate constant for exciton sharing at PSII, s-1
v.CB6F = 1.2./1e6;      % Cyt b6f density, mol sites m-2
v.RUB = 27.8./1e6;      % Rubisco density, mol sites m-2
v.eps1 = 0;             % PS I transfer function, mol mol-1

%% Run simulation and visualize results

% Set dynamic cross-sections and assign optimization function to 'v' 
v.alpha_opt = 'dynamic';
v.solve_xcs = solve_xcs;

% Run simulation
m = model_fun(v);

 % Compare measured and modeled values
[s] = plotter_forward_fun(outputname,v,m);

%% Save results
cd(workdir)

% Save figures in graphic format (.png)
set(s.figure1,'PaperPositionMode','auto');
set(s.figure1,'PaperUnits','inches','PaperPosition',[0 0 3 9])

print(s.figure1,fullfile(resultsdir,outputname,...
    strcat(outputname,'-figure1.png')),'-dpng','-r300'); 

% Save results in Matlab file format (.mat)
save(fullfile(resultsdir,outputname,...
    strcat(outputname,'-modelinputs.mat')),'v');
save(fullfile(resultsdir,outputname,...
    strcat(outputname,'-modeloutputs.mat')),'m'); 

% Return to project directory
cd(currdir);