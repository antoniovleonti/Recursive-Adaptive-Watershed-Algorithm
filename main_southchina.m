%{
Antonio Leonti
4.1.2020
main adapted specifically for batch scan
%}

clear;

%% load &/ make dataset

dset = "southchina";
ratio = 0.1;

load(sprintf("private\\data\\%s.mat", dset));
clear raw;

[x,y,z] = size(thresh);
z = z-mod(z,2); %make z even

%% modify dataset (morphological operations etc.)

fill = fill3d(thresh(:,:,1:z));

result = zeros(x,y,z, 'like', fill);

%% watershed

fprintf("Segmenting ''%s''...\n", dset);

%segment both halves
result(:,:,1:(z/2)) = segment(fill(:,:,1:(z/2)), ratio, 100);
result(:,:,(z/2):end) = segment(fill(:,:,(z/2):end), ratio, 100);

%segment where the halves meet
%result(:,:,(z/2):(z/2)+1) = segment(result(:,:,(z/2):(z/2)+1), ratio, 100);

lm = labelmatrix(bwconncomp(result, 6));

save(sprintf("private\\results\\%s", dset), "lm");

%% show &/ save results

%path = sprintf("private\\extracted\\%s\\%s\\",dset,replace(datestr(datetime),':','-'));

%fprintf("Extracting regions in ''%s'' to ''%s.''\n", dset, path);

%extractRegions(raw, lm, path, 27.7128); %sqrt(3 * (16^2)) = 27.7128