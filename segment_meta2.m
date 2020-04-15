%{  
Antonio Leonti
4.1.2020
This is a reimplementation of a mistake I made when programming
segment_meta which ended up giving favorable results.  The change this
offers is that it segments all data at once (in multiple passes, if needed.)
If you want to use an implementation as close to the original as possible,
use the new segment_meta function which implements what I originally intended
%}

function result = segment_meta2(data, ratio, calls)

    fprintf("%*cPass#: %d\n", calls,'', calls);
    
    %% copy data and create IEDM

    % crop data and only include this region's elements
    copy = data;
    % now create distance map
    iedm = -bwdist(~copy);

    %% modify local IEDM (if needed)

    % make list of all minima (do not include 0)
    tmp = unique(abs(imregionalmin(iedm) .* iedm));
    depths = tmp(2:end)'; % drop the zero, transpose

    %% perform bring-up transformation & segmentation

    % get index i of greatest difference depth_i - depth_i+1
    [~, index] = max([depths(2:end), NaN] - depths);
    % get d_i
    H = depths(index);

    % fill all the basins by H (imhmin)
    iedm = imhmin(iedm, H * ratio);
    % clip extremely deep basins to –H(1 – ratio)
    iedm(iedm < -H) = -H;

    % perform watershed segmentation
    segmented = watershed(iedm);

    %% repeat process (go deeper) iff new regions were found

    % determine if cut was successful
    if any(copy & (segmented == 0), 'all')

        segmented = segment_meta2(segmented, ratio, calls+1);
    end

    % transfer cuts to data
    data = data & ~(copy & (segmented == 0));
    
    % return the data
    result = data;
end