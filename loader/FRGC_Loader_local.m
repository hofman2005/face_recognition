function [img_train, index_train, img_gallery, index_gallery, img_probe, index_probe, id_hash_table] = FRGC_Loader_local(Version, Experiment, id_hash_table)

fprintf('Loading FRGC Version %d Experiment %d\n', Version, Experiment);

%% Path and file names
dataset_prefix = '/home/taowu/work/data/frgc-ver2/';

prefix = sprintf('%s/frgc_images/', dataset_prefix);

siz = [150, 130];

% prefix1 = '/fs/hidface/data/FRGC/1.0/BEE_DIST/data/norm/';
% prefix2 = '/fs/frgc-ver2/FRGC-2.0/BEE_DIST/data/norm/';

% if Version == 1
%     prefix = prefix1;
% elseif Version == 2
%     prefix = prefix2;
% else
%     error('Error: FRGC does not have version %d', Version);
% end

train_list_file = cell(2, 6);
gallery_list_file = cell(2,6);
probe_list_file = cell(2,6);
train_list_file{1,1}   = sprintf('%s/FRGC1.0/signature_sets/experiments/FRGC_Exp_1.0.1_Training.xml', dataset_prefix);
train_list_file{1,2}   = sprintf('%s/FRGC1.0/signature_sets/experiments/FRGC_Exp_1.0.2_Training.xml', dataset_prefix);
train_list_file{1,3}   = sprintf('%s/FRGC1.0/signature_sets/experiments/FRGC_Exp_1.0.3_Training.xml', dataset_prefix);
train_list_file{1,4}   = sprintf('%s/FRGC1.0/signature_sets/experiments/FRGC_Exp_1.0.4_Training.xml', dataset_prefix);
train_list_file{1,5}   = sprintf('%s/FRGC1.0/signature_sets/experiments/FRGC_Exp_1.0.5_Training.xml', dataset_prefix);
train_list_file{1,6}   = sprintf('%s/FRGC1.0/signature_sets/experiments/FRGC_Exp_1.0.6_Training.xml', dataset_prefix);
gallery_list_file{1,1} = sprintf('%s/FRGC1.0/signature_sets/experiments/FRGC_Exp_1.0.1_Gallery.xml', dataset_prefix);
gallery_list_file{1,2} = sprintf('%s/FRGC1.0/signature_sets/experiments/FRGC_Exp_1.0.2_Gallery.xml', dataset_prefix);
gallery_list_file{1,3} = sprintf('%s/FRGC1.0/signature_sets/experiments/FRGC_Exp_1.0.3_Gallery.xml', dataset_prefix);
gallery_list_file{1,4} = sprintf('%s/FRGC1.0/signature_sets/experiments/FRGC_Exp_1.0.4_Gallery.xml', dataset_prefix);
gallery_list_file{1,5} = sprintf('%s/FRGC1.0/signature_sets/experiments/FRGC_Exp_1.0.5_Gallery.xml', dataset_prefix);
gallery_list_file{1,6} = sprintf('%s/FRGC1.0/signature_sets/experiments/FRGC_Exp_1.0.6_Gallery.xml', dataset_prefix);
probe_list_file{1,1}   = sprintf('%s/FRGC1.0/signature_sets/experiments/FRGC_Exp_1.0.1_Probe.xml', dataset_prefix);
probe_list_file{1,2}   = sprintf('%s/FRGC1.0/signature_sets/experiments/FRGC_Exp_1.0.2_Probe.xml', dataset_prefix);
probe_list_file{1,3}   = sprintf('%s/FRGC1.0/signature_sets/experiments/FRGC_Exp_1.0.3_Probe.xml', dataset_prefix);
probe_list_file{1,4}   = sprintf('%s/FRGC1.0/signature_sets/experiments/FRGC_Exp_1.0.4_Probe.xml', dataset_prefix);
probe_list_file{1,5}   = sprintf('%s/FRGC1.0/signature_sets/experiments/FRGC_Exp_1.0.5_Probe.xml', dataset_prefix);
probe_list_file{1,6}   = sprintf('%s/FRGC1.0/signature_sets/experiments/FRGC_Exp_1.0.6_Probe.xml', dataset_prefix);
train_list_file{2,1}   = sprintf('%s/FRGC2.0/signature_sets/experiments/FRGC_Exp_2.0.1_Training.xml', dataset_prefix);
train_list_file{2,2}   = sprintf('%s/FRGC2.0/signature_sets/experiments/FRGC_Exp_2.0.2_Training.xml', dataset_prefix);
train_list_file{2,3}   = sprintf('%s/FRGC2.0/signature_sets/experiments/FRGC_Exp_2.0.3_Training.xml', dataset_prefix);
train_list_file{2,4}   = sprintf('%s/FRGC2.0/signature_sets/experiments/FRGC_Exp_2.0.4_Training.xml', dataset_prefix);
train_list_file{2,5}   = sprintf('%s/FRGC2.0/signature_sets/experiments/FRGC_Exp_2.0.5_Training.xml', dataset_prefix);
train_list_file{2,6}   = sprintf('%s/FRGC2.0/signature_sets/experiments/FRGC_Exp_2.0.6_Training.xml', dataset_prefix);
gallery_list_file{2,1} = sprintf('%s/FRGC2.0/signature_sets/experiments/FRGC_Exp_2.0.1_Target.xml', dataset_prefix);
gallery_list_file{2,2} = sprintf('%s/FRGC2.0/signature_sets/experiments/FRGC_Exp_2.0.2_Target.xml', dataset_prefix);
gallery_list_file{2,3} = sprintf('%s/FRGC2.0/signature_sets/experiments/FRGC_Exp_2.0.3_Target.xml', dataset_prefix);
gallery_list_file{2,4} = sprintf('%s/FRGC2.0/signature_sets/experiments/FRGC_Exp_2.0.4_Target.xml', dataset_prefix);
gallery_list_file{2,5} = sprintf('%s/FRGC2.0/signature_sets/experiments/FRGC_Exp_2.0.5_Target.xml', dataset_prefix);
gallery_list_file{2,6} = sprintf('%s/FRGC2.0/signature_sets/experiments/FRGC_Exp_2.0.6_Target.xml', dataset_prefix);
probe_list_file{2,1}   = sprintf('%s/FRGC2.0/signature_sets/experiments/FRGC_Exp_2.0.1_Query.xml', dataset_prefix);
probe_list_file{2,2}   = sprintf('%s/FRGC2.0/signature_sets/experiments/FRGC_Exp_2.0.2_Query.xml', dataset_prefix);
probe_list_file{2,3}   = sprintf('%s/FRGC2.0/signature_sets/experiments/FRGC_Exp_2.0.3_Query.xml', dataset_prefix);
probe_list_file{2,4}   = sprintf('%s/FRGC2.0/signature_sets/experiments/FRGC_Exp_2.0.4_Query.xml', dataset_prefix);
probe_list_file{2,5}   = sprintf('%s/FRGC2.0/signature_sets/experiments/FRGC_Exp_2.0.5_Query.xml', dataset_prefix);
probe_list_file{2,6}   = sprintf('%s/FRGC2.0/signature_sets/experiments/FRGC_Exp_2.0.6_Query.xml', dataset_prefix);

%% Global variables
if ~exist('id_hash_table', 'var')
    id_hash_table = sparse(10000, 1);
end

%% Load Gallery Set
disp('Loading gallery/target set...');
list_file = gallery_list_file{Version, Experiment};
fid = fopen(list_file, 'r');
content = fscanf(fid, '%s');
fclose(fid);

img_name = regexp(content, '(?<=/)(?:(?!/).)*(.jpg){1}', 'match');

img_gallery = zeros([siz, length(img_name)]);
index_gallery = zeros(length(img_name), 1);
for i = 1 : length(img_name)
    fprintf('Loading gallery image %d of %d\r', i, length(img_name));
    % img = NRM_Reader(strcat(prefix, img_name{i}(1:end-3), 'nrm'));
    img = imread(strcat(prefix, img_name{i}));
    img = rgb2gray(img);
    img = imresize(img, siz);
    
    id = regexp(img_name{i}, '\d*(?=d)', 'match');
    id = str2double(id{1});   
    [id, id_hash_table] = Assign_ID(id, id_hash_table);
    
    img_gallery(:,:,i) = img;
    index_gallery(i) = id;
end
fprintf('\n');

%% Load Probe Set
disp('Loading probe/query set...');
list_file = probe_list_file{Version, Experiment};
fid = fopen(list_file, 'r');
content = fscanf(fid, '%s');
fclose(fid);

img_name = regexp(content, '(?<=/)(?:(?!/).)*(.jpg){1}', 'match');

img_probe = zeros([siz, length(img_name)]);
index_probe = zeros(length(img_name), 1);
for i = 1 : length(img_name)
    fprintf('Loading probe image %d of %d\r', i, length(img_name));
    % img = NRM_Reader(strcat(prefix, img_name{i}(1:end-3), 'nrm'));
    img = imread(strcat(prefix, img_name{i}));
    img = rgb2gray(img);
    img = imresize(img, siz);
   
    id = regexp(img_name{i}, '\d*(?=d)', 'match');
    id = str2double(id{1});   
    [id, id_hash_table] = Assign_ID(id, id_hash_table);
    
    img_probe(:,:,i) = img;
    index_probe(i) = id;
end
fprintf('\n');

%% Load Training Set
disp('Loading training set...');
list_file = train_list_file{Version, Experiment};
fid = fopen(list_file, 'r');
content = fscanf(fid, '%s');
fclose(fid);

img_name = regexp(content, '(?<=/)(?:(?!/).)*(.jpg){1}', 'match');

img_train = zeros([siz, length(img_name)]);
index_train = zeros(length(img_name), 1);
for i = 1 : length(img_name)
    fprintf('Loading training image %d of %d\r', i, length(img_name));
    % img = NRM_Reader(strcat(prefix, img_name{i}(1:end-3), 'nrm'));
    img = imread(strcat(prefix, img_name{i}));
    img = rgb2gray(img);
    img = imresize(img, siz);
    
    id = regexp(img_name{i}, '\d*(?=d)', 'match');
    id = str2double(id{1});   
    [id, id_hash_table] = Assign_ID(id, id_hash_table);
    
    img_train(:,:,i) = img;
    index_train(i) = id;
end
fprintf('\n');

%% Load nrm file
% function A = NRM_Reader(filename)
% fid = fopen(filename);
% if fid == 0
%     error('Error in nrm_reader: Cannot read %s', filename);
% end
% a = fread(fid);
% fclose(fid);
% b = a(19:end);
% b = reshape(b, [4, size(b,1)/4]);
% A = zeros(size(b,2),1);
% parfor j = 1 : size(b,2)
%     A(j) = typecast(uint8(b(:,j)), 'single');
% end
% A = reshape(A, [130 150])';

%% ID Assigner
function [id, id_hash_table] = Assign_ID(id, id_hash_table)
if id_hash_table(id) == 0
    id_hash_table(id) = max(id_hash_table) + 1;
end
id = id_hash_table(id);
