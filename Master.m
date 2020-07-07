clear;

%%define the parameters for segmentation
job.modi=1;%1 for adaptive segmentation; 2 for traditional bring-up and bring-down
job.diff=1.01;%if adaptive segmentation is used (modi=1), this parameter is ignored <diff means a region with widely-ranged elements, bring-down method will be used
job.con=26;%default for 3D
job.noise=27;%regions with voxels less than this number will be removed
job.cutlarge=false;%default
job.uratio=0.15;job.dratio=1;%only applicable when modi==2;

job.aratio=0.125;%the fraction parameter
job.minarea=27000;%regions with voxels less than this number will not be segmented
job.disk1=strel('disk',1);
job.close_open=false;



%% filling the grains
load(sprintf("private\\data\\%s.mat", "batch"));
disp('filling');

dark_filled = fill3d(thresh);


water.dark=thresh;clear dark;
water.segment=dark_filled;
water.ridge=true(size(water.segment));
water.end=false;

while water.end==false
    water=F_water_main(water,job);
end

segment=water.dark & water.ridge;
save('segment','segment','job'); 

