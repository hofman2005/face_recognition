function [img_train, index_train, img_gallery, index_gallery, img_probe, index_probe, mask] = MURI_Loader()

%% Load list file
imgPrefix = '/fs/maritime/Labeling/temp/';

SignatureFile = '/hidhomes/taowu/work/Muri/signatures/exp.1.1.1.1.D1D2-1.1.1.1.D1D2/samples.mat';
Trial = 1;
n_Gallery = 15;

% n_PCA = 109;
% p_PCA = 0.95;
% 
% n_LDA = 16;
% n_kmean = 3;

disp('Parameters are set.');

%% W samples preparation
load(SignatureFile);
s_Gallery = ExpSignature.PictureNos(Trial, n_Gallery).PictureNosTrain;
s_Probe = ExpSignature.PictureNos(Trial, n_Gallery).PictureNosTest;

fid = fopen('/hidhomes/taowu/work/Muri/signatures/filelist','r');
FileNames = fscanf(fid, '%s');
fclose(fid);

expr = sprintf('Img[^(Img)]*(%s)\\.png{1}', strcat(sprintf('%8.8d|', s_Gallery),'00000000'));
GalleryFiles = regexp(FileNames, expr, 'match');
expr = sprintf('Img[^(Img)]*(%s)\\.png{1}', strcat(sprintf('%8.8d|', s_Probe),'00000000'));
ProbeFiles = regexp(FileNames, expr, 'match');

img_gallery = zeros(120, 120, size(GalleryFiles,2));
index_gallery = zeros(size(GalleryFiles,2), 1);
for i = 1 : size(GalleryFiles,2)
    temp = imread(strcat(imgPrefix, GalleryFiles{i}));
    img_gallery(:,:,i) = rgb2gray(temp);
    index_gallery(i) = str2num(GalleryFiles{i}(5:6));
end

img_probe = zeros(120, 120, size(ProbeFiles,2));
index_probe = zeros(size(ProbeFiles,2), 1);
for i =1 : size(ProbeFiles,2)
    temp = imread(strcat(imgPrefix, ProbeFiles{i}));
    img_probe(:,:,i) = rgb2gray(temp);
    index_probe(i) = str2num(ProbeFiles{i}(5:6));
end

img_gallery = img_gallery / 255;
img_probe = img_probe / 255;

% img_train = img_gallery;
% index_train = index_gallery;
img_train = zeros(128, 128, 0);
index_train = zeros(128, 128, 0);

mask = ones(size(img_gallery(:,:,1)));

disp('MURI samples are loaded.');

%% Mirror
temp = zeros(size(img_gallery,1),size(img_gallery,2),size(img_gallery,3)*2);
temp(:,:,1:size(img_gallery,3)) = img_gallery;
for i = 1 : size(img_gallery,3)
    temp(:,:,i+size(img_gallery,3)) = img_gallery(:, end:-1:1, i);
end
img_gallery = temp;
index_gallery = [index_gallery; index_gallery];

%% Normalize
% parfor i = 1 : size(img_train,3)
%     img = img_train(:,:,i);
%     img = img - mean(img(:));
%     img = img / std(img(:));
%     img_train(:,:,i) = img;
% end
% 
% parfor i = 1 : size(img_gallery,3)
%     img = img_gallery(:,:,i);
%     img = img - mean(img(:));
%     img = img / std(img(:));
%     img_gallery(:,:,i) = img;
% end
% 
% parfor i = 1 : size(img_probe,3)
%     img = img_probe(:,:,i);
%     img = img - mean(img(:));
%     img = img / std(img(:));
%     img_probe(:,:,i) = img;
% end

%% Gradient Face
parfor i = 1 : size(img_train,3)
    img = img_train(:,:,i);
    imgx = diff(img, 1, 1);
    imgy = diff(img, 1, 2);
    img2 = atan2(imgy(1:119, 1:119), imgx(1:119, 1:119));
    img_train(:,:,i) = imresize(img2, [120 120]);
end

parfor i = 1 : size(img_gallery,3)
    img = img_gallery(:,:,i);
    imgx = diff(img, 1, 1);
    imgy = diff(img, 1, 2);
    img2 = atan2(imgy(1:119, 1:119), imgx(1:119, 1:119));
    img_gallery(:,:,i) = imresize(img2, [120 120]);
end

parfor i = 1 : size(img_probe, 3)
    img = img_probe(:,:,i);
    imgx = diff(img, 1, 1);
    imgy = diff(img, 1, 2);
    img2 = atan2(imgy(1:119, 1:119), imgx(1:119, 1:119));
    img_probe(:,:,i) = imresize(img2, [120 120]);
end
