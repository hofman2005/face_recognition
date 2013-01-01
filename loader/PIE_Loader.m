function [img_train, index_train, img_gallery, index_gallery, img_probe, index_probe] = PIE_Loader(n_Gallery, n_Probe)

fprintf('Using PIE Loader, f1=%d, f2=%d\n', n_Gallery, n_Probe);

% load /fs/hidface/data/pie/Ipie_all.mat
load /home/taowu/data/pie/Ipie_all.mat

% img_gallery = zeros(48, 40, size(Ipie,2)*size(Ipie,4));
% index_gallery = zeros(size(Ipie,2)*size(Ipie,4),1);

% img_probe = zeros(48, 40, size(Ipie,2)*size(Ipie,4));
% index_probe = zeros(size(Ipie,2)*size(Ipie,4),1);

img_gallery = zeros(48, 40, size(Ipie,4));
index_gallery = zeros(size(Ipie,4),1);

img_probe = zeros(48, 40, size(Ipie,4));
index_probe = zeros(size(Ipie,4),1);

% pos_list = 1:numel(cset);
pos_list = 9;

for j = 1 : size(Ipie,4)
    for i = 1 : numel(pos_list)
        img_gallery(:,:,(j-1)*numel(pos_list)+i) = reshape(Ipie(:, pos_list(i), fset == n_Gallery, j), [48 40]);
        index_gallery((j-1)*numel(pos_list)+i) = j;
    end
end

for j = 1 : size(Ipie,4)
    for i = 1 : numel(pos_list)
        img_probe(:,:,(j-1)*numel(pos_list)+i) = reshape(Ipie(:, pos_list(i), fset == n_Probe, j), [48 40]);
        index_probe((j-1)*numel(pos_list)+i) = j;
    end
end

img_train = img_gallery;
index_train = index_gallery;

%% Nine Points
% disp('Generating new images...');
% img_temp = zeros(48, 40, size(img_gallery,3)*10);
% index_temp = zeros(size(img_gallery,3)*10,1);
% temp = cell(size(img_gallery,3),1);
% parfor i = 1 : size(img_gallery,3)
%     fprintf('Generating %d of %d\n', i, size(img_gallery,3));
%     a = generate_illum(img_gallery(:,:,i));
%     temp{i} = a;
% end
% for i = 1 : size(img_gallery,3)
%     img_temp(:,:,(i-1)*10+1) = img_gallery(:,:,i);
%     index_temp((i-1)*10+1) = index_gallery(i);
%     for j = 1 : 9
%         img_temp(:,:,(i-1)*10+1+j) = temp{i}(:,:,j);
%         index_temp((i-1)*10+1+j) = index_gallery(i);
%     end
% end
% img_gallery = img_temp;
% index_gallery = index_temp;

%% Mirror
% disp('Mirror images...');
% temp = zeros(size(img_train,1),size(img_train,2),size(img_train,3)*2);
% temp(:,:,1:size(img_train,3)) = img_train;
% for i = 1 : size(img_train,3)
%     temp(:,:,i+size(img_train,3)) = img_train(:, end:-1:1, i);
% end
% img_train = temp;
% index_train = [index_train; index_train];
% 
% temp = zeros(size(img_gallery,1),size(img_gallery,2),size(img_gallery,3)*2);
% temp(:,:,1:size(img_gallery,3)) = img_gallery;
% for i = 1 : size(img_gallery,3)
%     temp(:,:,i+size(img_gallery,3)) = img_gallery(:, end:-1:1, i);
% end
% img_gallery = temp;
% index_gallery = [index_gallery; index_gallery];

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
% disp('Normalizing 2 ...');
% m = mean(img_gallery,3);
% v = var(img_gallery,[],3);
% % v(v<0.1) = inf;
% parfor i = 1 : size(img_train,3)
%     img = img_train(:,:,i);
%     img = img - m;
%     img = img ./ v;
%     img_train(:,:,i) = img;
% end
% 
% parfor i = 1 : size(img_gallery,3)
%     img = img_gallery(:,:,i);
%     img = img - m;
%     img = img ./ v;
%     img_gallery(:,:,i) = img;
% end
% 
% parfor i = 1 : size(img_probe,3)
%     img = img_probe(:,:,i);
%     img = img - m;
%     img = img ./ v;
%     img_probe(:,:,i) = img;
% end

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

%% Verify
% for i = 1 : numel(index_gallery)
%     subplot(1,2,1),imshow(img_gallery(:,:,i),[]);
%     title(sprintf('Gallery. Number %d, Subject %d', i, index_gallery(i)));
%     subplot(1,2,2),imshow(img_probe(:,:,i),[]);
%     title(sprintf('Probe. Number %d, Subject %d', i, index_probe(i)));
%     pause(0.5);
% end
