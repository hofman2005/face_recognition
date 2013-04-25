%% Load
[img_train, index_train, img_gallery, index_gallery, img_probe, index_probe, id_hash_table] = FRGC_Loader_local(1, 2);
[img_train_extra, index_train_extra, img_gallery_extra, index_gallery_extra, img_probe_extra, index_probe_extra] = FRGC_Loader_local(2, 2, id_hash_table);

%% Load
o = load('FRGC_v1_Exp2_cache');
img_train       = o.img_train;
index_train     = o.index_train;
img_gallery     = o.img_gallery;
index_gallery   = o.index_gallery;
img_probe       = o.img_probe;
index_probe     = o.index_probe;
id_hash_table   = o.id_hash_table;

o = load('FRGC_v2_Exp2_cache');
img_train_extra       = o.img_train;
index_train_extra     = o.index_train;
img_gallery_extra     = o.img_gallery;
index_galleyr_extra   = o.index_gallery;
img_probe_extra       = o.img_probe;
index_probe_extra     = o.index_probe;
id_hash_table_extra   = o.id_hash_table;

%% Extra training
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

%% Quantize and reshape extra training
img_train_extra_2_q = zeros(size(img_train_extra_2));
for i = 1 : size(img_train_extra_2,3)
    img_train_extra_2_q(:,:,i) = myquantizer(img_train_extra_2(:,:,i), 2);
end
img_train_extra_2 = reshape(img_train_extra_2, size(img_train_extra_2,1)*size(img_train_extra_2,2), size(img_train_extra_2,3));
img_train_extra_2_q = reshape(img_train_extra_2_q, size(img_train_extra_2_q,1)*size(img_train_extra_2_q,2), size(img_train_extra_2_q,3));

%% Learn v1 and v2
num_atom = 500;
[v1, d1] = eigs(img_train_extra_2 * img_train_extra_2', num_atom);
[v2, d2] = eigs(img_train_extra_2_q * img_train_extra_2_q', num_atom);

%% Solve A
X = v1' * img_train_extra_2;
XQ = v2' * img_train_extra_2_q;
A = X * pinv(XQ);

%% Reconstruct
img_gallery_recover = v1 * A * v2' * img_gallery_q;
img_probe_recover = v1 * A * v2' * img_probe_q;
img_train_recover = v1 * A * v2' * img_train_extra_2_q;

%% PCA
n_PCA = 200;
% [W_PCA, D_PCA] = eigs(img_train_extra * img_train_extra', n_PCA);
[W_PCA, D_PCA] = eigs(img_train_recover * img_train_recover', n_PCA);

%%
fea_gallery = W_PCA' * img_gallery;
fea_probe = W_PCA' * img_probe;

fea_gallery_q = W_PCA' * img_gallery_recover;
fea_probe_q = W_PCA' * img_probe_recover;

%% LDA
W_LDA = LDATrain(fea_gallery_q, index_gallery);

%%
fea_gallery = W_LDA' * W_PCA' * img_gallery;
fea_probe = W_LDA' * W_PCA' * img_probe;

fea_gallery_q = W_LDA' * W_PCA' * img_gallery_recover;
fea_probe_q = W_LDA' * W_PCA' * img_probe_recover;

%% Training classifier
test_fea_gallery = fea_gallery_q;
test_fea_probe   = fea_probe_q;

class_gallery = zeros(size(test_fea_gallery,1), max(index_gallery));
for i = 1 : max(index_gallery)%max_hash
    class_gallery(:,i) = mean(test_fea_gallery(:,index_gallery==i), 2);
end
index_class_gallery = (1:max(index_gallery))';
disp('Training classifier done.');

%% Testing
Dist = zeros(size(test_fea_probe,2), size(class_gallery,2));
for i = 1 : size(test_fea_probe, 2)
    dist = test_fea_probe(:,i)' * class_gallery ./ norm(test_fea_probe(:,i));
    Dist(i,:) = acos(dist ./ sqrt(sum(class_gallery.^2,1)));
end

[Y, Index] = sort(Dist, 2, 'ascend');
nRank = 17;
Accuracy = zeros(nRank, 1);
for rank = 1 : nRank
    Correct = ones(size(test_fea_probe,2),1);
    for i = 1 : rank
        res = index_class_gallery(Index(:,i));
%         res = back_hash(Index(:,i));
        Correct = Correct .* (~(res==index_probe));
    end
    Accuracy(rank) = (size(Correct,1)-sum(Correct))/size(Correct,1);
end
figure(1);plot(1:nRank, Accuracy);title('CMS - Arccos Distance');
cmc = Accuracy;
Accuracy = sum(index_class_gallery(Index(:,1)) == index_probe) / size(test_fea_probe, 2);
% Accuracy = sum(back_hash(Index(:,1)) == index_probe) / size(feature_probe, 2);
disp(Accuracy);