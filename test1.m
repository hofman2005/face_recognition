[v1,d1] = eigs(img_train_extra_2*img_train_extra_2', 500);
[v2, d2] = eigs(img_train_extra_2_q*img_train_extra_2_q', 500);

%%
fea_train = img_train_extra;

% fea_gallery = v1 * A * v2' * img_gallery_q;
fea_gallery = img_gallery;
fea_probe = img_probe;
fea_probe_q = v1 * A * v2' * img_probe_q;

%%
fea_train = reshape(fea_train, [48,48,size(fea_train,2)]);

fea_gallery = reshape(fea_gallery, [48,48,size(fea_gallery,2)]);
fea_probe = reshape(fea_probe, [48,48,size(fea_probe,2)]);
fea_probe_q = reshape(fea_probe_q, [48,48,size(fea_probe_q,2)]);

%%
H = fspecial('gaussian', 3);

for i = 1 : size(fea_train,3)
    fea_train(:,:,i) = fea_train(:,:,i) ./ imfilter(fea_train(:,:,i), H);
end

for i = 1 : size(fea_gallery,3)
    fea_gallery(:,:,i) = fea_gallery(:,:,i) ./ imfilter(fea_gallery(:,:,i), H);
end
for i = 1 : size(fea_probe,3)
    fea_probe(:,:,i) = fea_probe(:,:,i) ./ imfilter(fea_probe(:,:,i), H);
end
for i = 1 : size(fea_probe_q,3)
    fea_probe_q(:,:,i) = fea_probe_q(:,:,i) ./ imfilter(fea_probe_q(:,:,i), H);
end

%% Mirror the gallery images
fea_gallery_mirror = zeros(size(fea_gallery));
for i = 1 : size(fea_gallery,3)
    fea_gallery_mirror(:,:,i) = fea_gallery(:, end:-1:1, i);
end
fea_gallery = cat(3, fea_gallery, fea_gallery_mirror);
index_gallery_mirror = cat(1, index_gallery, index_gallery);

%%
fea_train = reshape(fea_train, [size(fea_train,1)*size(fea_train,2), size(fea_train,3)]);

fea_gallery = reshape(fea_gallery, [size(fea_gallery,1)*size(fea_gallery,2), size(fea_gallery,3)]);
fea_probe = reshape(fea_probe, [size(fea_probe,1)*size(fea_probe,2), size(fea_probe,3)]);
fea_probe_q = reshape(fea_probe_q, [size(fea_probe_q,1)*size(fea_probe_q,2), size(fea_probe_q,3)]);

%%
[W_PCA, M_PCA] = PCATrain(fea_train, 150);
W_LDA = LDATrain(W_PCA' * bsxfun(@minus, fea_gallery, M_PCA), index_gallery_mirror);

fea_gallery = W_LDA' * W_PCA' * bsxfun(@minus, fea_gallery, M_PCA);
fea_probe = W_LDA' * W_PCA' * bsxfun(@minus, fea_probe, M_PCA);
fea_probe_q = W_LDA' * W_PCA' * bsxfun(@minus, fea_probe_q, M_PCA);

nn_classifier(fea_gallery, index_gallery_mirror, fea_probe, index_probe);
% nn_classifier(fea_gallery, index_gallery_mirror, fea_probe_q, index_probe);