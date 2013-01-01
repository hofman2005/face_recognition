function [img_train, index_train, img_gallery, index_gallery, img_probe, index_probe] = AR_Loader()

%% Open file list
fid = fopen('ARlist.lst','r');
content = fscanf(fid, '%s');
fclose(fid);

%% Load images
% 50 male, 50 female, with only illumination change and expression.
% allsidelight, anger, leftlight, neutral, rightlight, scream, smile

prefix = '/fs/hidface/data/ARFace/pngimages/';

condition = cell(7,1);
condition{1} = 'allsidelight';
condition{2} = 'anger';
condition{3} = 'leftlight';
condition{4} = 'neutral';
condition{5} = 'rightlight';
condition{6} = 'scream';
condition{7} = 'smile';

img_gallery = zeros(128, 128, 2*50*7);
index_gallery = zeros(2*50*7, 1);

img_probe = zeros(128, 128, 2*50*7);
index_probe = zeros(2*50*7, 1);

count = 1;
subject = 1;
id = 1;
for i = 1 : 76
    imagename = {};
    for j = 1 : 7
        keyword = sprintf('/%s/m-%3.3d', condition{j}, id);
        expr = sprintf('\\.(?:(?!(\\./)).)*%s(?:(?!(\\./)).)*png{1}', keyword);
        name = regexp(content, expr, 'match');
        imagename = [imagename name];
    end
    if length(imagename) ~= 14
        id = id + 1;
        continue;
    end
    
    fprintf('Loading subject %d male.\n', subject);
    index_gallery(count : count+6) = subject;
    index_probe(count : count+6) = subject;
    
    for j = 1 : 7
        img = imread(strcat(prefix, imagename{j*2-1}(3:end)));
        img = img(135:476, 287:520, :);
        img_gallery(:,:,count) = imresize(rgb2gray(img), [128 128]);
%         img_gallery(:,:,count) = rgb2gray(img(206:370, 325:444, :));
        img = imread(strcat(prefix, imagename{j*2}(3:end)));
        img = img(135:476, 287:520, :);
        img_probe(:,:,count) = imresize(rgb2gray(img), [128 128]);
%         img_probe(:,:,count) = rgb2gray(img(206:370, 325:444, :));
        count = count + 1;
    end
    subject = subject + 1;
    id = id + 1;
    
    if subject > 50
        break;
    end
end

id = 1;
for i = 1 : 60
    imagename = {};
    for j = 1 : 7
        keyword = sprintf('/%s/w-%3.3d', condition{j}, id);
        expr = sprintf('\\.(?:(?!(\\./)).)*%s(?:(?!(\\./)).)*png{1}', keyword);
        name = regexp(content, expr, 'match');
        imagename = [imagename name];
    end
    if length(imagename) ~= 14
        id = id + 1;
        continue;
    end
    
    fprintf('Loading subject %d female.\n', subject);
    index_gallery(count : count+6) = subject;
    index_probe(count : count+6) = subject;
    
    for j = 1 : 7
        img = imread(strcat(prefix, imagename{j*2-1}(3:end)));
        img = img(135:476, 287:520, :);
        img_gallery(:,:,count) = imresize(rgb2gray(img), [128 128]);
%         img_gallery(:,:,count) = rgb2gray(img(206:370, 325:444, :));
        img = imread(strcat(prefix, imagename{j*2}(3:end)));
        img = img(135:476, 287:520, :);
        img_probe(:,:,count) = imresize(rgb2gray(img), [128 128]);
%         img_probe(:,:,count) = rgb2gray(img(206:370, 325:444, :));
        count = count + 1;
    end
    subject = subject + 1;
    id = id + 1;
    
    if subject > 100
        break;
    end
end

img_train = img_gallery;
index_train = index_gallery;

%% Verify
% for i = 1 : numel(index_gallery)
%     subplot(1,2,1),imshow(img_gallery(:,:,i),[-0.05 0.05]);
%     title(sprintf('Gallery. Number %d, Subject %d', i, index_gallery(i)));
%     subplot(1,2,2),imshow(img_probe(:,:,i),[-0.05 0.05]);
%     title(sprintf('Probe. Number %d, Subject %d', i, index_probe(i)));
%     pause(0.5);
% end

%% Mirror
disp('Mirror images...');
temp = zeros(size(img_train,1),size(img_train,2),size(img_train,3)*2);
temp(:,:,1:size(img_train,3)) = img_train;
for i = 1 : size(img_train,3)
    temp(:,:,i+size(img_train,3)) = img_train(:, end:-1:1, i);
end
img_train = temp;
index_train = [index_train; index_train];

temp = zeros(size(img_gallery,1),size(img_gallery,2),size(img_gallery,3)*2);
temp(:,:,1:size(img_gallery,3)) = img_gallery;
for i = 1 : size(img_gallery,3)
    temp(:,:,i+size(img_gallery,3)) = img_gallery(:, end:-1:1, i);
end
img_gallery = temp;
index_gallery = [index_gallery; index_gallery];

%% Preprocess
%% Normalize 1
% disp('Normalizing');
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

%% Normalize 2
disp('Normalizing 2 ...');
m = mean(img_gallery,3);
v = var(img_gallery,[],3);
% v(v<0.1) = inf;
parfor i = 1 : size(img_train,3)
    img = img_train(:,:,i);
    img = img - m;
    img = img ./ v;
    img_train(:,:,i) = img;
end

parfor i = 1 : size(img_gallery,3)
    img = img_gallery(:,:,i);
    img = img - m;
    img = img ./ v;
    img_gallery(:,:,i) = img;
end

parfor i = 1 : size(img_probe,3)
    img = img_probe(:,:,i);
    img = img - m;
    img = img ./ v;
    img_probe(:,:,i) = img;
end

%% Gradient Face
% disp('Calculating Gradient Face...');
% parfor i = 1 : size(img_train,3)
%     img = img_train(:,:,i);
%     imgx = diff(img, 1, 1);
%     imgy = diff(img, 1, 2);
%     img2 = atan2(imgy(1:end-1,1:end), imgx(1:end,1:end-1));
%     img_train(:,:,i) = imresize(img2, size(img));
% end
% 
% parfor i = 1 : size(img_gallery,3)
%     img = img_gallery(:,:,i);
%     imgx = diff(img, 1, 1);
%     imgy = diff(img, 1, 2);
%     img2 = atan2(imgy(1:end-1,1:end), imgx(1:end,1:end-1));
%     img_gallery(:,:,i) = imresize(img2, size(img));
% end
% 
% parfor i = 1 : size(img_probe, 3)
%     img = img_probe(:,:,i);
%     imgx = diff(img, 1, 1);
%     imgy = diff(img, 1, 2);
%     img2 = atan2(imgy(1:end-1,1:end), imgx(1:end,1:end-1));
%     img_probe(:,:,i) = imresize(img2, size(img));
% end