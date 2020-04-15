load private\results\batch.mat;
load private\data\batch.mat

path = sprintf("private\\extracted\\%s\\%s\\","batch",replace(datestr(datetime),':','-'));

fprintf("Extracting regions in ''%s'' to ''%s.''\n", "batch", path);

extractRegions(raw, lm, path, 27.7128); %sqrt(3 * (16^2)) = 27.7128;