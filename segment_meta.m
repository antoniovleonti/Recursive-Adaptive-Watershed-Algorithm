%{  
Antonio Leonti
4.1.2020
This is a reimplmentation of the algo from the paper "Quantification of the
morphology of shelly carbonate sands using 3D images" by D. KONG and J.
FONSECA (http://dx.doi.org/10.1680/jgeot.16.P.278). This code is easier to
read and faster than the original code. It's also recursive, which is cool.
%}

function result = segment_meta(data, ratio, minVolume, calls)
    %% identify disjoint regions in data

    % get connected components
    cc = bwconncomp(data);
    % get volume for each connected component
    s = regionprops3(cc, "Volume", "BoundingBox");
    % create a label matrix of data from connected components
    label = labelmatrix(cc);

    %% for each of the regions...
    
    numRegions = max(label, [], "all");

    for i = 1 : numRegions
        
        fprintf("%*c %d / %d \n", 2*calls, '|', i, numRegions);

        if s.Volume(i) >= minVolume
            %% obtain the region of interest and create IEDM

            % find indices of data which contain the current region
            bb = [ceil(s.BoundingBox(i,1:3)), s.BoundingBox(i,4:6)-1];
            % crop data and only include this region's elements
            crop = imcrop3((label == i), bb);
            
            % now create distance map
            iedm = -bwdist(~crop);

            %% modify local IEDM (if needed)

            % make list of all minima (do not include 0)
            tmp = unique(abs(imregionalmin(iedm) .* iedm));
            depths = tmp(2:end)'; % drop the zero
            
            if numel(depths) >= 2
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

                % determine if region was cut
                if any(crop & (segmented == 0), 'all')
                    % resegment if it was
                    segmented = segment_meta(segmented, ratio, minVolume, calls+1);
                end
                
                x = bb(2):sum(bb([2,5]));
                y = bb(1):sum(bb([1,4]));
                z = bb(3):sum(bb([3,6]));
                
                % transfer cuts to data
                data(x,y,z) = imcrop3(data, bb) & ~(crop & (segmented == 0));
            end
        end
    end
    
    % return the data
    result = data;
end