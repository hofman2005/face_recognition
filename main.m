% main.m

%% Load dataset
f1 = 8;
f2 = 17;
[img_train, index_train, img_gallery, index_gallery, img_probe, index_probe] = PIE_Loader_pose(f1, f2);

[img_train, index_train, img_gallery, index_gallery, img_probe, index_probe] = Preprocess(img_train, index_train, img_gallery, index_gallery, img_probe, index_probe);

%% Quantize

%% Reshape
img_train = reshape(img_train, size(img_train,1)*size(img_train,2), size(img_train,3));
img_gallery = reshape(img_gallery, size(img_gallery,1)*size(img_gallery,2), size(img_gallery,3));
img_probe   = reshape(img_probe, size(img_probe,1)*size(img_probe,2), size(img_probe,3));

%% PCA
img_train = img_gallery;
index_train = index_gallery;
[img_train, img_gallery, img_probe] = PCA_DR(img_train, img_gallery, img_probe, 504);

%% Learn
% data_train = reshape(img_train, [size(img_train,1)*size(img_train,2), size(img_train,3)]);
% N = 100;
% D = learn_dict_main(data_train,  N);

% [D, Dq, X] = LearnMCDict(img_train, img_train, index_train);
D = cell(max(index_gallery), 1);
for i = 1 : max(index_gallery)
    fprintf('Learning %d of %d\n', i, max(index_gallery));
    [d, dq, x] = LearnMCDict(img_gallery(:, index_gallery==i), img_gallery(:, index_gallery==i), ones(sum(index_gallery==i), 1), 15, 15);
    D{i} = d;
end

%% Test
%% Identify
disp('Identifying ...');
Dist = zeros(size(img_probe,2), numel(D));
pinvD = cell(size(D));
parfor i = 1 : numel(D)
    pinvD{i} = pinv(D{i});
end
tic
for i = 1 : size(img_probe,2)
    Dist(i,:) = identify(img_probe(:,i), D, pinvD)';
end
t = toc;
fprintf('Average time per sample: %f seconds.\n', t/size(img_probe,2));

%% Result
% Rank 1 accuracy
[Y,I] = sort(Dist,2);

% Reject #1
ratio = Y(:,1)./Y(:,2);

% Reject #2
% ratio = var(Y(:,2:end),[],2)./var(Y,[],2);

thres = 10;
Correct = (I(:,1) == index_probe);
Accuracy = sum(Correct(ratio<=thres)) / length(index_probe(ratio<=thres));
RejectRatio = 1-sum(ratio<thres)/sum(index_probe>0);
fprintf('Accuracy %4.2f%%  RejectRatio %4.2f%%\n', Accuracy*100, RejectRatio*100);