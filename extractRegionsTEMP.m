function extractRegionsTEMP(data, labelMask, path, minHypot)
    mkdir(path);
    
    %% identify disjoint regions in data
    
    if isempty(labelMask)
        % create a label matrix of data from connected components
        labelMask = labelmatrix(bwconncomp(data));
    end
    
    stat = regionprops3(labelMask, "BoundingBox");
    %% for each of the regions...
    
    numRegions = max(labelMask, [], "all");
    
    meta = zeros(numRegions,7);
    
    for i = 1 : 82418
        
        fprintf("%d / %d \n", i, 82418);
        
        x = ceil(stat.BoundingBox(i,1));
        y = ceil(stat.BoundingBox(i,2));
        z = ceil(stat.BoundingBox(i,3));
        dx = stat.BoundingBox(i,4);
        dy = stat.BoundingBox(i,5);
        dz = stat.BoundingBox(i,6);
        
        % check hypotenuse length
        if (sqrt(dx.^2 + dy.^2 + dz.^2) >= minHypot)
            % add region metadata
            meta(i,:) = [i, x, y, z, dx, dy, dz];
        end
    end
    
    for i = 82419 : numRegions
        fprintf("%d / %d \n", i, numRegions);
        
        % find indices of data which contain the current region
        x = ceil(stat.BoundingBox(i,1));
        y = ceil(stat.BoundingBox(i,2));
        z = ceil(stat.BoundingBox(i,3));
        dx = stat.BoundingBox(i,4);
        dy = stat.BoundingBox(i,5);
        dz = stat.BoundingBox(i,6);
        
        % check hypotenuse length
        if (sqrt(dx.^2 + dy.^2 + dz.^2) >= minHypot)
            % create folder
            mkdir(sprintf("%s\\%d\\", path, i));
            % add region metadata
            meta(i,:) = [i, x, y, z, dx, dy, dz];
            
            % crop data and only include this region's elements
            crop = cast((labelMask(x:dx,y:dy,z:dz) == i),'like',data) .* data(x:dx,y:dy,z:dz);
            
            for j = 1 : dz
                % save image
                imwrite(crop(:,:,j), sprintf("%s\\%d\\%d.png",path,i,j));
            end
        end
    end
    
    writematrix(meta, sprintf("%s\\meta.csv", path));
end