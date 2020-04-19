load("private\extracted\batch\18-Apr-2020 17-27-30\lm.mat")

rgb = zeros(925,932,3,658, 'uint8');

for i = 1:658
    rgb(:,:,:,i) = label2rgb(lm(:,:,i), 'jet','w','shuffle');
end

save("rgb.mat", "rgb");