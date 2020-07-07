%{
Antonio Leonti
4.1.2020
main adapted specifically for batch scan
%}

clear;

%% load &/ make dataset

dset = "ledge";

load(sprintf("private\\data\\%s.mat", dset));

%% modify dataset (morphological operations etc.)

fill = fill3d(thresh);

result = zeros(1004, 1024, 1018, 'like', fill);

%% watershed

fprintf("Segmenting ''%s''...\n", dset);

%result = segment(fill, 0.06, 100);

result(:,:,1:460) = segment(fill(:,:,1:509), 0.06, 100);
result(:,:,461:end) = segment(fill(:,:,510:end), 0.06, 100);

result(:,:,230:690) = segment(result(:,:,509:510), 0.06, 100);

lm = labelmatrix(bwconncomp(result, 6));

save(sprintf("private\\results\\%s", dset), "lm");

%% show &/ save results

%path = sprintf("private\\extracted\\%s\\%s\\",dset,replace(datestr(datetime),':','-'));

%fprintf("Extracting regions in ''%s'' to ''%s.''\n", dset, path);

%extractRegions(raw, lm, path, 27.7128); %sqrt(3 * (16^2)) = 27.7128