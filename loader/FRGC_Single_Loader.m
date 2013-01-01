function [img_gallery, index_gallery, id_hash_table] = FRGC_Single_Loader(list_file, prefix, id_hash_table)
% [img, index, id_hash_table] = FRGC_Single_Loader(list_file, prefix, id_hash_table)

%% Global variables
if ~exist('id_hash_table')
    id_hash_table = sparse(10000, 1);
end

%% Load Gallery Set
disp('Loading images...');
fid = fopen(list_file, 'r');
content = fscanf(fid, '%s');
fclose(fid);

img_name = regexp(content, '(?<=(file-name="))(?:(?!(file-name)).)*(.jpg){1}', 'match');

img_gallery = zeros(150, 130, length(img_name));
index_gallery = zeros(length(img_name), 1);
for i = 1 : length(img_name)
    fprintf('Loading image %d of %d\r', i, length(img_name));
    img = NRM_Reader(strcat(prefix, img_name{i}(1:end-3), 'nrm'));
    
    id = regexp(img_name{i}, '(?<=/)\d*(?=d)', 'match');
    id = str2double(id{1});   
    [id, id_hash_table] = Assign_ID(id, id_hash_table);
    
    img_gallery(:,:,i) = img;
    index_gallery(i) = id;
end
fprintf('\n');

%% Load nrm file
function A = NRM_Reader(filename)
fid = fopen(filename);
if fid == 0
    error('Error in nrm_reader: Cannot read %s', filename);
end
a = fread(fid);
fclose(fid);
b = a(19:end);
b = reshape(b, [4, size(b,1)/4]);
A = zeros(size(b,2),1);
parfor j = 1 : size(b,2)
    A(j) = typecast(uint8(b(:,j)), 'single');
end
A = reshape(A, [130 150])';

%% ID Assigner
function [id, id_hash_table] = Assign_ID(id, id_hash_table)
if id_hash_table(id) == 0
    id_hash_table(id) = max(id_hash_table) + 1;
end
id = id_hash_table(id);
