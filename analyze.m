function outputArg1 = analyze(fill)
    %% prep
    % enumerate regions
    label = labelmatrix(bwconncomp(fill));
    
    numRegions = max(label, [], "all");
    
    for i = 1 : numRegions
        %% w/ discretized points from find()
        % find() particle voxels
        points = ind2sub(size(fill), find(label==i));
        % convex hull: convhulln()
        vcon = convhulln(points);
        % PCA: pca()
        [a,b,c,I_e,I_f] = pca(points);
        %% surface mesh boundary()
        poly = boundary(points);
        % vertex curvatures: vertexNormal(), vertexAttachments
        % Calculate circumscribed sphere (how???)
    end
    outputArg1 = inputArg1;
end