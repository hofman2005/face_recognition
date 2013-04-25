% main.m

%% Load dataset
f1 = 8;
f2 = 17;
% [img_train, index_train, img_gallery, index_gallery, img_probe, index_probe] = PIE_Loader_pose(f1, f2);
[img_train, index_train, img_gallery, index_gallery, img_probe, index_probe, id_hash_table] = FRGC_Loader_local(1, 2);

% [img_train_ori, index_train_ori, img_gallery_ori, index_gallery_ori, img_probe, index_probe, id_hash_table] = FRGC_Loader_local(1, 2);
[img_train_extra, index_train_extra, img_gallery_extra, index_gallery_extra, img_probe_extra, index_probe_extra] = FRGC_Loader_local(2, 2, id_hash_table);

% [img_train, index_train, img_gallery, index_gallery, img_probe, index_probe] = Preprocess(img_train, index_train, img_gallery, index_gallery, img_probe, index_probe);

%% Extend the training/gallery set.
% img_train = cat(3, img_train_ori, img_train_extra);
% index_train = cat(1, index_train_ori, index_train_extra);
% img_gallery = cat(3, img_gallery_ori, img_gallery_extra);
% index_gallery = cat(1, index_gallery_ori, index_gallery_extra);

%%
index = find(index_train_extra > 152);
img_train_extra_2 = img_train_extra(:,:, index);
index_train_extra_2 = index_train_extra(index);

%% Quantize
img_gallery_q = zeros(size(img_gallery));
for i = 1 : size(img_gallery,3)
    img_gallery_q(:,:,i) = myquantizer(img_gallery(:,:,i), 2);
end
img_probe_q = zeros(size(img_probe));
for i = 1 : size(img_probe,3)
    img_probe_q(:,:,i) = myquantizer(img_probe(:,:,i), 2);
end
img_train_q = zeros(size(img_train));
for i = 1 : size(img_train,3)
    img_train_q(:,:,i) = myquantizer(img_train(:,:,i), 2);
end

%% Reshape
img_train = reshape(img_train, size(img_train,1)*size(img_train,2), size(img_train,3));
img_train_q = reshape(img_train_q, size(img_train_q,1)*size(img_train_q,2), size(img_train_q,3));
img_gallery = reshape(img_gallery, size(img_gallery,1)*size(img_gallery,2), size(img_gallery,3));
img_probe   = reshape(img_probe, size(img_probe,1)*size(img_probe,2), size(img_probe,3));
img_gallery_q = reshape(img_gallery_q, size(img_gallery_q,1)*size(img_gallery_q,2), size(img_gallery_q,3));
img_probe_q   = reshape(img_probe_q, size(img_probe_q,1)*size(img_probe_q,2), size(img_probe_q,3));

%%
img_train_extra_2_q = zeros(size(img_train_extra_2));
for i = 1 : size(img_train_extra_2,3)
    img_train_extra_2_q(:,:,i) = myquantizer(img_train_extra_2(:,:,i), 2);
end
img_train_extra_2 = reshape(img_train_extra_2, size(img_train_extra_2,1)*size(img_train_extra_2,2), size(img_train_extra_2,3));
img_train_extra_2_q = reshape(img_train_extra_2_q, size(img_train_extra_2_q,1)*size(img_train_extra_2_q,2), size(img_train_extra_2_q,3));

%% PCA
% img_train = img_gallery;
% index_train = index_gallery;
% [img_train, img_gallery, img_probe] = PCA_DR(img_train, img_gallery, img_probe, 504);

%% Learn
% data_train = reshape(img_train, [size(img_train,1)*size(img_train,2), size(img_train,3)]);
% N = 100;
% D = learn_dict_main(data_train,  N);

% [D, Dq, X] = LearnMCDict(img_train, img_train, index_train);
% D = cell(max(index_gallery), 1);
% for i = 1 : max(index_gallery)
%     fprintf('Learning %d of %d\n', i, max(index_gallery));
%     [d, dq, x] = LearnMCDict(img_gallery(:, index_gallery==i), img_gallery(:, index_gallery==i), ones(sum(index_gallery==i), 1), 15, 15);
%     D{i} = d;
% end

% [D, DQ, X, W] = LearnMCDict(img_gallery, img_gallery_q, index_gallery, 200, 200);

%% Learn 2
% num_atom = 500;
% sparsity = 2;
% 
% [D, ~, X, W] = LearnMCDict(img_gallery, [], index_gallery, num_atom, sparsity);
% [DQ, ~, XQ, WQ] = LearnMCDict(img_gallery_q, [], index_gallery, num_atom, sparsity);

%% Learn3
% num_atom = 100;
% sparsity = 10;
% 
% [D, DQ, X, W] = LearnMCDict(img_gallery, img_gallery_q, index_gallery, num_atom, sparsity);
% 
% D_ = ink_svd(D);
% DQ_ = ink_svd(DQ);

%% Learn4
clear params;
sparsity = 50;
dictsize = 500;

params.Tdata = sparsity;
params.dictsize = dictsize;

params.data = img_gallery;
params.initdict = img_gallery;
params.iternum = 10;

[D,X] = ksvd(params);

params.data = img_gallery_q;
params.initdict = img_gallery_q;
params.iternum = 10;

[DQ,XQ] = ksvd(params);

%% Learn5
clear params;
sparsity = 20;
dictsize = 1500;

params.Tdata = sparsity;
params.dictsize = dictsize;

params.data = img_train_extra_2;
params.initdict = img_train_extra_2;
params.iternum = 10;

[D,X] = ksvd(params);

params.data = img_train_extra_2_q;
params.initdict = img_train_extra_2_q;
params.iternum = 10;

[DQ,XQ] = ksvd(params);

%%
% [v,d] = eig(D'*D);
% D = D * v;
% 
% [v,d] = eig(DQ'*DQ);
% DQ = DQ * v;

%% Learn5
% clear params;
% sparsity = 15;
% dictsize = 500;
% 
% params.Tdata = sparsity;
% params.dictsize = dictsize;
% 
% params.data = [img_gallery; img_gallery_q];
% params.initdict = params.data;
% params.iternum = 10;
% 
% [d, X] = ksvd(params);
% 
% D = D(1:size(img_gallery,1), :);
% DQ = D(size(img_gallery,1)+1:end, :);

%% Update X after ink_svd
% X = zeros(size(D,2), size(img_gallery,2));
% parfor i = 1 : size(img_gallery, 2)
%     X(:,i) = OrthogonalMatchingPursuit(img_gallery(:,i), D, sparsity);
% end
% XQ = zeros(size(DQ,2), size(img_gallery_q,2));
% parfor i = 1 : size(img_gallery_q, 2)
%     XQ(:,i) = OrthogonalMatchingPursuit(img_gallery_q(:,i), DQ, sparsity);
% end

% A = X*XQ'*pinv(XQ*XQ');
A = X * pinv(XQ);

%% Test
%% Identify
% disp('Identifying ...');
% Dist = zeros(size(img_probe,2), numel(D));
% pinvD = cell(size(D));
% parfor i = 1 : numel(D)
%     pinvD{i} = pinv(D{i});
% end
% tic
% for i = 1 : size(img_probe,2)
%     Dist(i,:) = identify(img_probe(:,i), D, pinvD)';
% end
% t = toc;
% fprintf('Average time per sample: %f seconds.\n', t/size(img_probe,2));

% Dist = zeros(size(img_probe,2), size(W,1));
% parfor i = 1 : size(img_probe,2)
%     [x, res] = OrthogonalMatchingPursuit(img_probe(:,i), D, 20);
%     Dist(i,:) = exp(-(W*x))';
% end

%% Verification
X_probe = zeros(size(D,2), size(img_probe, 2));
parfor i = 1 : size(img_probe,2)
    [x, res] = OrthogonalMatchingPursuit(img_probe(:,i), D, sparsity);
    X_probe(:,i) = x;
end
XQ_probe = zeros(size(DQ,2), size(img_probe, 2));
parfor i = 1 : size(img_probe,2)
    [x, res] = OrthogonalMatchingPursuit(img_probe_q(:,i), DQ, sparsity);
    XQ_probe(:,i) = x;
end

% d = pdist2(X_probe', XQ_probe');
% dd = d + max(d(:)) * eye(size(d));
% 
% [x, y] = meshgrid(1:size(img_probe,2), 1:size(img_probe,2));
% gt = index_probe(x) == index_probe(y);
% gt = double(gt)*2-1;
% [fpr, tpr, err] = roc_analysis(dd(:), gt(:));
%

%% OMP
X = full(omp(D'*img_gallery, D'*D, sparsity));
XQ = full(omp(DQ'*img_gallery_q, DQ'*DQ, sparsity));
X_probe = full(omp(D'*img_probe, D'*D, sparsity));
XQ_probe = full(omp(DQ'*img_probe_q, DQ'*DQ, sparsity));

%%
X = pinv(D)*img_gallery;
XQ = pinv(DQ)*img_gallery_q;
X_probe = pinv(D)*img_probe;
XQ_probe = pinv(DQ)*img_probe;

%%
A = X * pinv(XQ);

gamma = 5000;
H = zeros(max(index_gallery), length(index_gallery));
for i = 1 : length(index_gallery)
    H(index_gallery(i), i) = 1;
end
W = H * X' * pinv(X*X' + gamma * eye(size(X,1)));

%% Identify for full dictionary
% X_probe = pinv(D_) * img_probe;
% X_probe = A*pinv(DQ_) * img_probe_q;
Dist = exp(-(W*A*XQ_probe));
Dist = Dist';

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