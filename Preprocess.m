function [img_train, index_train, img_gallery, index_gallery, img_probe, index_probe] = Preprocess(img_train, index_train, img_gallery, index_gallery, img_probe, index_probe)

%% Before-Partition
% disp('Before-Partition ...');
% pos_t = 111;
% pos_b = 192;
% pos_l = 1;
% pos_r = 168;
% new_size = [pos_b-pos_t+1, pos_r-pos_l+1];
% temp = zeros(new_size(1), new_size(2), size(img_train,3));
% parfor i = 1 : size(img_train, 3)
%     temp(:,:,i) = img_train(pos_t:pos_b,pos_l:pos_r,i);
% end
% img_train = temp;
% temp = zeros(new_size(1), new_size(2), size(img_gallery, 3));
% parfor i = 1 : size(img_gallery, 3)
%     temp(:,:,i) = img_gallery(pos_t:pos_b,pos_l:pos_r,i);
% end
% img_gallery = temp;
% temp = zeros(new_size(1), new_size(2), size(img_probe, 3));
% parfor i = 1 : size(img_probe, 3)
%     temp(:,:,i) = img_probe(pos_t:pos_b,pos_l:pos_r,i);
% end
% img_probe = temp;
% clear temp;
 
%% For FRGC only
% disp('Gray level preprocess for FRGC ...');
% h = fspecial('gaussian', [5 5], 1);
% parfor i = 1 : size(img_train,3)
%     img_train(:,:,i) = img_train(:,:,i)*64+128;
%     img_train(:,:,i) = imfilter(img_train(:,:,i), h);
% end
% parfor i = 1 : size(img_gallery,3)
%     img_gallery(:,:,i) = img_gallery(:,:,i)*64+128;
%     img_gallery(:,:,i) = imfilter(img_gallery(:,:,i), h);
% end
% parfor i = 1 : size(img_probe,3)
%     img_probe(:,:,i) = img_probe(:,:,i)*64+128;
%     img_probe(:,:,i) = imfilter(img_probe(:,:,i), h);
% end

%% Down sample
new_size = [48 40];
fprintf('Downsampling to [%d,%d]...\n', new_size(1), new_size(2));
temp = zeros(new_size(1), new_size(2), size(img_train,3));
parfor i = 1 : size(img_train, 3)
    temp(:,:,i) = imresize(img_train(:,:,i), new_size);
end
img_train = temp;
temp = zeros(new_size(1), new_size(2), size(img_gallery, 3));
parfor i = 1 : size(img_gallery, 3)
    temp(:,:,i) = imresize(img_gallery(:,:,i), new_size);
end
img_gallery = temp;
temp = zeros(new_size(1), new_size(2), size(img_probe, 3));
parfor i = 1 : size(img_probe, 3)
    temp(:,:,i) = imresize(img_probe(:,:,i), new_size);
end
img_probe = temp;
clear temp;

%% Corruption
% percentage = 0.3;
% fprintf('Corrupting probe set. Level %2.2f%%\n', percentage*100);
% siz = [size(img_probe,1) size(img_probe,2)];
% parfor i = 1 : size(img_probe,3)
%     mask = rand(siz) < percentage;
%     value = rand(siz)*255;
%     img = img_probe(:,:,i);
%     img(mask) = value(mask);
%     img_probe(:,:,i) = img;
% end

%% Random block
% percentage = 0.3;
% fprintf('Randomly block probe set. Level %2.0f%%\n', percentage*100);
% percentage = sqrt(percentage);
% siz = [size(img_probe,1) size(img_probe,2)];
% content = rand(round(siz*percentage))*255;
% % content = imread('../4.2.03.tiff');
% % content = double(rgb2gray(content));
% % content = imresize(content, round(siz*percentage));
% siz_c = size(content);
% parfor i = 1 : size(img_probe,3)
%     pos_x = max(round(rand(1)*(siz(1)-siz_c(1))),1);
%     pos_y = max(round(rand(1)*(siz(2)-siz_c(2))),1);
%     img = img_probe(:,:,i);
%     img(pos_x:pos_x+siz_c(1)-1, pos_y:pos_y+siz_c(2)-1) = content;
%     img_probe(:,:,i) = img;
% end

%% Nine Points
disp('Generating new images ...');
img_temp = zeros(48, 40, size(img_gallery,3)*8);
index_temp = zeros(size(img_gallery,3)*8,1);
temp = cell(size(img_gallery,3),1);
parfor i = 1 : size(img_gallery,3)
    fprintf('Generating %d of %d\n', i, size(img_gallery,3));
    a = generate_illum(img_gallery(:,:,i));
    temp{i} = a;
end
for i = 1 : size(img_gallery,3)
    img_temp(:,:,(i-1)*8+1) = img_gallery(:,:,i);
    index_temp((i-1)*8+1) = index_gallery(i);
    for j = 1 : 7
        img_temp(:,:,(i-1)*8+1+j) = temp{i}(:,:,j+2);
        index_temp((i-1)*8+1+j) = index_gallery(i);
    end
end
% for i = 1 : size(img_gallery,3)
%     img_temp(:,:,(i-1)*10+1) = img_gallery(:,:,i);
%     index_temp((i-1)*10+1) = index_gallery(i);
%     for j = 1 : 9
%         img_temp(:,:,(i-1)*10+1+j) = temp{i}(:,:,j);
%         index_temp((i-1)*10+1+j) = index_gallery(i);
%     end
% end
img_gallery = img_temp;
index_gallery = index_temp;

%% Re-sample
new_size = [64 64];
fprintf('Resample to [%d, %d].\n', new_size(1), new_size(2));
temp = zeros(new_size(1), new_size(2), size(img_train,3));
parfor i = 1 : size(img_train, 3)
    temp(:,:,i) = imresize(img_train(:,:,i), new_size);
end
img_train = temp;
temp = zeros(new_size(1), new_size(2), size(img_gallery, 3));
parfor i = 1 : size(img_gallery, 3)
    temp(:,:,i) = imresize(img_gallery(:,:,i), new_size);
end
img_gallery = temp;
temp = zeros(new_size(1), new_size(2), size(img_probe, 3));
parfor i = 1 : size(img_probe, 3)
    temp(:,:,i) = imresize(img_probe(:,:,i), new_size);
end
img_probe = temp;
clear temp;

%% Duplicate
% disp('Duplicate images ...');
% temp = zeros(size(img_train,1),size(img_train,2),size(img_train,3)*2);
% temp(:,:,1:size(img_train,3)) = img_train;
% for i = 1 : size(img_train,3)
%     temp(:,:,i+size(img_train,3)) = img_train(:, :, i);
% end
% img_train = temp;
% index_train = [index_train; index_train];
% 
% temp = zeros(size(img_gallery,1),size(img_gallery,2),size(img_gallery,3)*2);
% temp(:,:,1:size(img_gallery,3)) = img_gallery;
% for i = 1 : size(img_gallery,3)
%     temp(:,:,i+size(img_gallery,3)) = img_gallery(:, :, i);
% end
% img_gallery = temp;
% index_gallery = [index_gallery; index_gallery];

%% Smooth
% disp('Smoothing ...');
% h = fspecial('gaussian', [5 5], 1);
% parfor i = 1 : size(img_train,3)
%    img_train(:,:,i) = imfilter(img_train(:,:,i), h);
% end
% parfor i = 1 : size(img_gallery,3)
%    img_gallery(:,:,i) = imfilter(img_gallery(:,:,i), h);
% end
% parfor i = 1 : size(img_probe,3)
%    img_probe(:,:,i) = imfilter(img_probe(:,:,i), h);
% end

%% Gradient Face
% disp('Calculating Gradient Face ...');
% for i = 1 : size(img_train,3)
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

%% After-Partition
% disp('After-Partition ...');
% pos_t = 52;
% pos_b = 95;
% pos_l = 35;
% pos_r = 101;
% new_size = [pos_b-pos_t+1, pos_r-pos_l+1];
% temp = zeros(new_size(1), new_size(2), size(img_train,3));
% parfor i = 1 : size(img_train, 3)
%     temp(:,:,i) = img_train(pos_t:pos_b,pos_l:pos_r,i);
% end
% img_train = temp;
% temp = zeros(new_size(1), new_size(2), size(img_gallery, 3));
% parfor i = 1 : size(img_gallery, 3)
%     temp(:,:,i) = img_gallery(pos_t:pos_b,pos_l:pos_r,i);
% end
% img_gallery = temp;
% temp = zeros(new_size(1), new_size(2), size(img_probe, 3));
% parfor i = 1 : size(img_probe, 3)
%     temp(:,:,i) = img_probe(pos_t:pos_b,pos_l:pos_r,i);
% end
% img_probe = temp;
% clear temp;
% 

%% Re-sample
% disp('Re-sampling ...');
% new_size = [64 64];
% temp = zeros(new_size(1), new_size(2), size(img_train,3));
% parfor i = 1 : size(img_train, 3)
%     temp(:,:,i) = imresize(img_train(:,:,i), new_size);
% end
% img_train = temp;
% temp = zeros(new_size(1), new_size(2), size(img_gallery, 3));
% parfor i = 1 : size(img_gallery, 3)
%     temp(:,:,i) = imresize(img_gallery(:,:,i), new_size);
% end
% img_gallery = temp;
% temp = zeros(new_size(1), new_size(2), size(img_probe, 3));
% parfor i = 1 : size(img_probe, 3)
%     temp(:,:,i) = imresize(img_probe(:,:,i), new_size);
% end
% img_probe = temp;
% clear temp;

%% INFace Toolbox
disp('Preprocessing with INFace Toolbox ...');
siz1 = size(img_train,1);
siz2 = size(img_train,2);
siz = 128;
parfor i = 1 : size(img_train,3)
    temp = img_train(:,:,i);
    temp = wavelet_denoising(imresize(temp, [siz siz]),'haar');
    img_train(:,:,i) = imresize(temp, [siz1, siz2]);
end
parfor i = 1 : size(img_gallery,3)
    temp = img_gallery(:,:,i);
    temp = wavelet_denoising(imresize(temp, [siz siz]),'haar');
    img_gallery(:,:,i) = imresize(temp, [siz1, siz2]);
end
parfor i = 1 : size(img_probe,3)
    temp = img_probe(:,:,i);
    temp = wavelet_denoising(imresize(temp, [siz siz]),'haar');    
    img_probe(:,:,i) =imresize(temp, [siz1, siz2]);
end

%% Mirror
disp('Mirror images ...');
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

clear temp;

%% Down sample
% new_size = [24 21];
% fprintf('Downsampling to [%d,%d]...\n', new_size(1), new_size(2));
% temp = zeros(new_size(1), new_size(2), size(img_train,3));
% parfor i = 1 : size(img_train, 3)
%     temp(:,:,i) = imresize(img_train(:,:,i), new_size);
% end
% img_train = temp;
% temp = zeros(new_size(1), new_size(2), size(img_gallery, 3));
% parfor i = 1 : size(img_gallery, 3)
%     temp(:,:,i) = imresize(img_gallery(:,:,i), new_size);
% end
% img_gallery = temp;
% temp = zeros(new_size(1), new_size(2), size(img_probe, 3));
% parfor i = 1 : size(img_probe, 3)
%     temp(:,:,i) = imresize(img_probe(:,:,i), new_size);
% end
% img_probe = temp;
% clear temp;
