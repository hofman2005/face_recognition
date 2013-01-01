function [img_train, index_train, img_gallery, index_gallery, img_probe, index_probe] = AR_Cropped_Loader();

disp('Loading cropped AR database...');

prefix = '/scratch0/ARFace_Cropped/cropped/';

condition=[1 2 3 4 5 6 7; 14 15 16 17 18 19 20];

img_gallery = zeros(165,120,2*50*7);
index_gallery = zeros(2*50*7,1);

for i = 1 : 50
    for j = 1 : 7
        file_name = sprintf('M-%3.3d-%2.2d.bmp', i, condition(1,j));
        img = imread(strcat(prefix, file_name));
        img_gallery(:,:,(i-1)*7+j) = rgb2gray(img);
        index_gallery((i-1)*7+j) = i;
    end
end
for i = 1 : 50
    for j = 1 : 7
        file_name = sprintf('W-%3.3d-%2.2d.bmp', i, condition(1,j));
        img = imread(strcat(prefix, file_name));
        img_gallery(:,:,(i-1)*7+j+50*7) = rgb2gray(img);
        index_gallery((i-1)*7+j+50*7) = i+50;
    end
end

img_probe = zeros(165,120,2*50*7);
index_probe = zeros(2*50*7,1);

for i = 1 : 50
    for j = 1 : 7
        file_name = sprintf('M-%3.3d-%2.2d.bmp', i, condition(2,j));
        img = imread(strcat(prefix, file_name));
        img_probe(:,:,(i-1)*7+j) = rgb2gray(img);
        index_probe((i-1)*7+j) = i;
    end
end
for i = 1 : 50
    for j = 1 : 7
        file_name = sprintf('W-%3.3d-%2.2d.bmp', i, condition(2,j));
        img = imread(strcat(prefix, file_name));
        img_probe(:,:,(i-1)*7+j+50*7) = rgb2gray(img);
        index_probe((i-1)*7+j+50*7) = i+50;
    end
end

img_train = img_gallery;
index_train = index_gallery;

