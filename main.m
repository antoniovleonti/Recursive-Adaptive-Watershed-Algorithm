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

load("private\data\partition.mat");


%% modify dataset (morphological operations etc.)

fill = fill3d(data);

%% watershed

fprintf("Beginning segmentation...\n");

result = segment(fill, 0.125, 26, 27000);

%% show &/ save results

cc = bwconncomp(result, 6);
lm = labelmatrix(cc) .* uint16(data);

rgb = label2rgb(lm(:,:,15),'jet','w','shuffle');

imshow(rgb);

save("private\results\partition", "result");