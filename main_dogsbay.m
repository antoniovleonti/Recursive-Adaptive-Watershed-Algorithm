%{
Antonio Leonti | aleonti@umassd.edu
4.1.2020
driver function for recursive segmentation algo
%}

clear;

%% user-tunable variables

% folder which contains your data & folder to save results to
lpath = "private\\data\\";
spath = "private\\results\\";

% name of dataset in private\data\<dset>.mat
% * assumes existence of:
%   - "raw", the original greyscale 3d image
%   - "thresh", the thresholded ("logical"/binary) version of raw.
dset = "dogsbay";

% bring up ratio to be used for watershed segmentation
bu_ratio = 0.00025;

% number of times to split image.
% - resizes the image to make # of images (z axis) divisible by this number
% - 1 to segment entire image as one (make sure you have enough memory)
% - might be useful if you are having trouble finding the right bu_ratio
parts = 12;

% 1/ol_ratio = the fraction of the previous part to be included in this part (overlap)
% ex. ol_ratio = 2; -> 1/(2) of each part overlaps w/ subsequent part
% - needed because objects shared between two parts will not be segmented
%   correctly, so you need to segment them "from both directions"
% - make sure ol_ratio > 0 and no one gets hurt.
ol_ratio = 2;

%% load and prepare dataset for segmentation

load(sprintf("%s%s.mat", lpath, dset));
clear raw; % only needed for classification - saving memory

% make sure number of images is divisible by parts
[~,~,z] = size(thresh);
thresh = thresh(:,:, 1 : z - mod(z,parts));
[x,y,z] = size(thresh); % update size variables

% apply 3d fill to remove internal voids
fill = fill3d(thresh);

result = zeros(x,y,z, 'like', fill);

%% watershed

len = z / parts; % the length of each part
overlap = (len - mod(len, ol_ratio)) / ol_ratio; % overlap amount

for i = 1 : parts
    % range to be included in this part 
    rng = (i-1)*len - (i~=1)*overlap + (i==1) : i*len;
    % keep user informed
    fprintf("- PART %d / %d... (%d : %d / %d)\n", i, parts, rng(1), rng(end), z);
    % finally, segment and store
    result(:,:,rng) = segment(fill(:,:,rng), bu_ratio, 100);
end

lm = labelmatrix(bwconncomp(result, 6));

save(sprintf("%s%s", spath, dset), "lm");

%% show &/ save results

%savepath = sprintf("private\\extracted\\%s\\%s\\",dset,replace(datestr(datetime),':','-'));

%fprintf("Extracting regions in ''%s'' to ''%s.''\n", dset, path);

%extractRegions(raw, lm, path, 27.7128); %sqrt(3 * (16^2)) = 27.7128