function [img_train, index_train, img_gallery, index_gallery, img_probe, index_probe] = YaleB_Loader(reload)

% YaleB database loader and preprocess
fprintf('Using YaleB Loader.\n');

%% Load all images
% prefix = '/fs/hidface/data/yaleB/CroppedYale/';
prefix = '/home/taowu/work/data/CroppedYale/';
clear all_images;
all_images = zeros(192, 168, 38*65);
all_images_index = zeros(38*65, 1);
id = 1;
pos = 1;
for i = 1 : 39
    if i == 14
        continue;
    end
%     filename = strcat(prefix, sprintf('yaleB%2.2d/yaleB%2.2d_P00.info',i,i));
%     filename = sprintf('/hidhomes/taowu/work/MP/my_matlab/yaleB/yaleB%2.2d_P00.info', i);
    filename = sprintf('loader/yaleB/yaleB%2.2d_P00.info', i);
    fid = fopen(filename,'r');
    content = fscanf(fid, '%s');
    fclose(fid);
    
    imagename = regexp(content, '(yale)(?:(?!yale|Ambient).)*pgm{1}', 'match');
    
    for j = 1 : length(imagename)
        filename = strcat(prefix, sprintf('yaleB%2.2d/%s',i, imagename{j}));
        if i == 16
            filename(54)='0';
        end
        if exist(filename,'file')==0
            continue;
        end
        image = imread(filename);
        if size(image,1) ~= 192 || size(image,2) ~= 168
            continue;
        end
        all_images(:,:,pos) = double(image);
        all_images_index(pos) = id;
        pos = pos + 1;
    end
    id = id + 1;
end

%% Generate train, gallery and probe set
num_gallery = 32;

img_train = zeros(192, 168, 38*0);
index_train = zeros(38*0, 1);

img_gallery = zeros(192, 168, 38*num_gallery);
index_gallery = zeros(38*num_gallery,1);

p_siz = sum(all_images_index>0)-38*num_gallery;
% p_siz = 38*11;
img_probe = zeros(192, 168, p_siz);
index_probe = zeros(p_siz, 1);

p_train = 1;
p_gallery = 1;
p_probe = 1;
all_index = cell(38, 1);
if ~reload
    load YaleB_index
end
for i = 1 : 38
    index = find(all_images_index==i);
    
    if reload
        index = index(randperm(length(index)));
        all_index{i} = index;
    else
        index = all_index{i};
    end
    t_index = index(1:0);
    g_index = index(1:num_gallery);
    p_index = index(num_gallery+1:end);
    
    img_train(:,:,p_train:p_train+length(t_index)-1) = all_images(:,:,t_index);
    index_train(p_train:p_train+length(t_index)-1) = i;
    p_train = p_train + length(t_index);
    
    img_gallery(:,:,p_gallery:p_gallery+length(g_index)-1) = all_images(:,:,g_index);
    index_gallery(p_gallery:p_gallery+length(g_index)-1) = i;
    p_gallery = p_gallery + length(g_index);
    
    img_probe(:,:,p_probe:p_probe+length(p_index)-1) = all_images(:,:,p_index);
    index_probe(p_probe:p_probe+length(p_index)-1) = i;
    p_probe = p_probe + length(p_index);
end
if reload
    save('YaleB_index', 'all_index');
end
clear all_images;

% img_train = img_gallery;
% index_train = index_gallery;
img_gallery = img_gallery(:,:,index_gallery>0);
index_gallery = index_gallery(index_gallery>0);

img_probe = img_probe(:,:,index_probe>0);
index_probe = index_probe(index_probe>0);


