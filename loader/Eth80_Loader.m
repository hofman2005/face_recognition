% This loader is only used for testing the ROC of the rejection rule in the
% paper.

function [img_train, index_train, img_gallery, index_gallery, img_probe, index_probe] = Eth80_Loader(reload)


prefix = '/fs/hidface/data/Eth80/eth80-cropped256/';
list_file = 'loader/Eth80/all.lst';
selected_list_file = 'loader/Eth80/selected.mat';
num_probe = 1198;

img_train = zeros([0,0,0]);
index_train = zeros([0,0,0]);
img_gallery = zeros([0,0,0]);
index_gallery = zeros([0,0,0]);

if reload == 1 || ~exist(selected_list_file, 'file')
    cmd = sprintf('find %s | grep png > %s', prefix, list_file);
    system(cmd);
    cmd = sprintf('sed -i -e "s|%s||" -e "/map/d" %s', prefix, list_file);
    system(cmd);
    list = textread(list_file, '%s'); 
    index = randperm(length(list));
    index = index(1:num_probe);
    list = list(index);
    save(selected_list_file, 'list');
    warning('New index is generated for Eth80');
else
    fprintf('Loading pre-selected list.\n');
end

load(selected_list_file);

img_probe = zeros(256,256,length(list));
index_probe = -ones(length(list), 1);
for i = 1 : length(list)
    img = imread(strcat(prefix, list{i}));
    img_probe(:,:,i) = rgb2gray(img);
end