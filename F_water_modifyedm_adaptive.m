function MEDM=F_water_modifyedm_adaptive(EDM,aratio)%EDM already has negative values
LM          =   imregionalmin(EDM);
Minvalues   =   EDM.*LM;

values=unique(abs(Minvalues));
depths=values(2:end);
depths=depths';
basins=numel(depths);

MEDM=EDM;

if basins>=2%at least two catchments found;
    temp1=[depths(2:end),0];
    temp2=temp1-depths;
    ind=find(temp2==max(temp2));
    
    cri_depth=depths(ind(1));

    MEDM            = imhmin(EDM,aratio*cri_depth);
    MEDM(MEDM<-cri_depth)=-cri_depth;
    
end
      

