function lm = suppressRegions(labelMask)
    
    %% for each of the regions...
    meta = csvread("private\extracted\batch\18-Apr-2020 17-27-30\meta.csv");
    lm = zeros(size(labelMask), 'like', labelMask);
    numRegions = max(labelMask, [], "all");
    
    for i = 1 : numRegions
        fprintf("%d / %d \n", i, numRegions);
        
        if(meta(i,1) ~= 0)
            lm(labelMask==i) = i;
        end
    end
end