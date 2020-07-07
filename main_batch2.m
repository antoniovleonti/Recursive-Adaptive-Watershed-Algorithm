%{
Antonio Leonti
4.1.2020
main adapted specifically for batch scan
%}

%%define the parameters for segmentation
job.modi=1;%1 for adaptive segmentation; 2 for traditional bring-up and bring-down
job.diff=1.01;%if adaptive segmentation is used (modi=1), this parameter is ignored <diff means a region with widely-ranged elements, bring-down method will be used
job.con=26;%default for 3D
job.noise=27;%regions with voxels less than this number will be removed
job.cutlarge=false;%default
job.uratio=0.15;job.dratio=1;%only applicable when modi==2;

job.aratio=0.1;%the fraction parameter
job.minarea=10000;%regions with voxels less than this number will not be segmented
job.disk1=strel('disk',1);
job.close_open=false;

clear;

%% load &/ make dataset

dset = "batch";

load(sprintf("private\\data\\%s.mat", dset));


%% modify dataset (morphological operations etc.)

raw = raw(:,:,1:658);
thresh = thresh(:,:,1:658);

fill = fill3d(thresh);



%% watershed

fprintf("Segmentating ''%s''...\n", dset);

result = F_water_main(fill, job);


lm = labelmatrix(bwconncomp(result, 6));
lm = lm .* cast(thresh, "like", lm);

save(sprintf("private\\results\\%s", dset), "lm");

%% show &/ save results

path = sprintf("private\\extracted\\%s\\%s\\",dset,replace(datestr(datetime),':','-'));

fprintf("Extracting regions in ''%s'' to ''%s.''\n", dset, path);

extractRegions(raw, lm, path, 27.7128); %sqrt(3 * (16^2)) = 27.7128