% This is the install script for the INface toolbox. 
% 
% All this script does is 
% adding the toolbox paths to Matlabs search path and compiles the C code to 
% produce the mex files needed by the toolbox. It should be noted that all 
% components of the toolbox were tested with Matlab version 7.5.0.342 
% (R2007b) and WindowsXP Professional (SP3) OS.
% 
% I have not tested any of the code on a Linux machine. Nevertheless, I see 
% no reason why it should not work on Linux as well (except maybe for the 
% part were the path is added in this script). If this script fails 
% just compile the c++ code yourself and add the path to the toolbox together 
% with all subdirectories to Matlabs search path.
% 
% As always, if you haven't done so yet, type "mex -setup" prior to running 
% this script to select an appropriate compiler from the ones available to 
% you.


%% Get current directory and add all subdirectories to path
current = pwd;
addpath(current);
addpath([current '/auxilary']);
addpath([current '/mex']);
addpath([current '/histograms']);
addpath([current '/photometric']);
savepath


%% Produce the mex (matlab executables) files
mex mex/perform_nlmeans_mex.cpp
mex mex/perform_nlmeans_mex1.cpp