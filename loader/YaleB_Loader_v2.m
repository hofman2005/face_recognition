function [img_train, index_train, img_gallery, index_gallery, img_probe, index_probe] = YaleB_Loader_v2(reload)

% YaleB database loader and preprocess
fprintf('Using YaleB Loader Version 2.\n');

%% Load all images
prefix = '/fs/hidface/data/yaleB/CroppedYale/';
clear all_images;
all_images = zeros(192, 168, 38*65);
all_images_index = zeros(38*65, 1);
id = 1;
pos = 1;
labels = cell(38,1);
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
    [imagename label] = sort_names(imagename);
    
    pos2 = 1;
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
        
        labels{id}(pos2)=label(j);
        pos2 = pos2 + 1;
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
% p_siz = 38*30;
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
    label = labels{i};
    
%     if reload
%         index = index(randperm(length(index)));
%         all_index{i} = index;
%     else
%         index = all_index{i};
%     end
% 
%     t_index = index(1:0);
%     g_index = index(1:num_gallery);
%     p_index = index(num_gallery+1:end);

    t_index = index(1:0);
    g_index = index(label<=2);
    p_index = index(label==3);    
    
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

function [imagename label] = sort_names(imagename)
index = 1 : length(imagename);
label = zeros(length(imagename), 1);
for i = 1 :length(imagename)
    s1 = str2double(imagename{i}(14:16));
    s2 = str2double(imagename{i}(19:20));
    
    if s1<=12 && s2<=12
        label(i) = 1;
    elseif s1<=25 && s2<=25
        label(i) = 2;
    elseif s1<=50 && s2<=50
        if ~(s1==50 && s2 == 40)
            label(i) = 3;
        else
            label(i) = 4;
        end
    elseif s1<=77 && s2<=77
        label(i) = 4;
    else
        label(i) = 5;
    end
    
    if strcmp(imagename{i}, 'yaleB02_P00A+025E+00.pgm') || ...
            strcmp(imagename{i}, 'yaleB02_P00A+020E-10.pgm') ||...
            strcmp(imagename{i}, 'yaleB05_P00A+035E+15.pgm') ||...
            strcmp(imagename{i}, 'yaleB05_P00A+035E+40.pgm')
        label(i) = 6;
    end
    
end
index = [index(label==1) index(label==2) index(label==3) index(label==4) index(label==5)];
label = [label(label==1); label(label==2); label(label==3); label(label==4); label(label==5)];
imagename = imagename(index);