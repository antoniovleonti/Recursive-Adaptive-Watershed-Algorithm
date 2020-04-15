function extractRegions(data, labelMask, path, minHypot)
    mkdir(path); % get path ready
    
    %% identify disjoint regions in data
    
    if isempty(labelMask)
        % create a label matrix of data from connected components
        labelMask = labelmatrix(bwconncomp(data));
    end
    
    %% for each of the regions...
    s = regionprops3(labelMask, "BoundingBox");
    numRegions = max(labelMask, [], "all");
    
    meta = zeros(numRegions,7); % preallocate metadata matrix
    
    for i = 1 : numRegions
        fprintf("%d / %d \n", i, numRegions);
        
        % get rectangular bounding box (make data from s.BoundingBox useable)
        bbox = [ceil(s.BoundingBox(i,1:3)), s.BoundingBox(i,4:6)-1];
        
        % check hypotenuse length
        if (sqrt(sum(bbox(4:6).^2)) >= minHypot)
            % create folder
            mkdir(sprintf("%s\\%d\\", path, i));
            % add region metadata
            meta(i,:) = [i, bbox];
            
            % crop label mask and typecast to be the same as data
            temp = cast(imcrop3((labelMask==i),bbox),'like',data);
            % transfer over original data where cropped region == 1
            crop = temp .* imcrop3(data, bbox);

            for j = 1 : bbox(6)
                % save image
                imwrite(crop(:,:,j), sprintf("%s\\%d\\%d.png",path,i,j));
            end
        end
    end
    
    writematrix(meta, sprintf("%s\\meta.csv", path));
end