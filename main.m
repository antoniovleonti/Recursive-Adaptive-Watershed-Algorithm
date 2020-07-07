%{
Antonio Leonti
4.1.2020
Attempting to rewrite the code from the paper "Quantification of the
morphology of shelly carbonate sands using 3D images" by D. KONG and J.
FONSECA. This code is easier to read and better at its intended purpose.

Algorithm /concept is from: http://dx.doi.org/10.1680/jgeot.16.P.278
%}

clear;

%% load &/ make dataset

dset = "small";

load(sprintf("private\\data\\%s.mat", dset));


%% modify dataset (morphological operations etc.)

fill = fill3d(data);

%% watershed

fprintf("Segmentating ''%s''...\n", dset);

result = F_water_main(fill, 0.1, 10000);

lm = labelmatrix(bwconncomp(result, 6));

save(sprintf("private\\results\\%s", dset), "lm");

%% show &/ save results

path = sprintf("private\\extracted\\%s\\%s\\",dset,replace(datestr(datetime),':','-'));

fprintf("Extracting regions in ''%s'' to ''%s.''\n", dset, path);

extractRegions(data, lm, path, 27.7128); %sqrt(3 * (16^2)) = 27.7128