% DFR Dictionary Training
% 
% Author:       Tao Wu
% Email:        taowu@umiacs.umd.edu
% Last update:  11/12/2010

function Dict = mp_train(img_gallery, index_gallery, dictsize, iternum)

addpath(genpath(pwd));

if exist('dictsize', 'var')
    ds = dictsize;
else
    ds = 15;
end

if exist('iternum', 'var')
    in = iternum;
else
    in = 20;
end

init_dictionary = cell(size(img_gallery,2), 1);
for i = 1 : size(img_gallery, 2)
    init_dictionary{i} = img_gallery(:,i);
end

% Train book
clear params;
D = cell(max(index_gallery), 1);
params = cell(max(index_gallery),1);
for i = 1 : max(index_gallery)
    params{i}.data = img_gallery(:,index_gallery==i);
    params{i}.Tdata = 20;
    params{i}.dictsize = min(ds, sum(index_gallery==i));
    %params{i}.initdict = img_gallery(:,index_gallery==i);
    params{i}.iternum = in;
end
for i = 1 : max(index_gallery)
    fprintf('Training class %d ...\n', i);
    d = ksvd(params{i}, '');
    D{i} = d;
end

pinvD = cell(size(D));
for i = 1 : numel(D)
    pinvD{i} = pinv(D{i});
end

Dict.D = D;
Dict.pinvD = pinvD;

