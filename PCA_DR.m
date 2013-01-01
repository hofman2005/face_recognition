function [img_train, img_gallery, img_probe, W_PCA] = PCA_DR(img_train, img_gallery, img_probe, cutoff)

if cutoff < 1
    fprintf('PCA_DR is running, cut to %2.2f%% energy\n', cutoff);
else
    fprintf('PCA_DR is running, cut to %d dimension\n', cutoff);
end

%% Preprocess
img_train = img_train / 255;
parfor i = 1 : size(img_train,2)
    img_train(:,i) = histeq(img_train(:,i));
end
img_mean = mean(img_train, 2);
img_var = var(img_train,[],2);
parfor i = 1 : size(img_train,2)
    img_train(:,i) = img_train(:,i) - img_mean;
    img_train(:,i) = img_train(:,i) ./ sqrt(img_var);
end

img_gallery = img_gallery / 255;
img_probe   = img_probe / 255;
parfor i = 1 : size(img_gallery,2)
    img_gallery(:,i) = histeq(img_gallery(:,i));
    img_gallery(:,i) = img_gallery(:,i) - img_mean;
    img_gallery(:,i) = img_gallery(:,i) ./ sqrt(img_var);
end
parfor i = 1 : size(img_probe,2)
    img_probe(:,i) = histeq(img_probe(:,i));
    img_probe(:,i) = img_probe(:,i) - img_mean;
    img_probe(:,i) = img_probe(:,i) ./ sqrt(img_var);
end
disp('PCA Preprocess done.');

%% Train PCA -- Eigen decomposition
if size(img_train,2) < size(img_train,1)
    C = img_train'*img_train;
    [FullV, FullD] = eig(C);
    FullD = diag(FullD);
    FullD = FullD(end:-1:1);
    FullV = FullV(:, end:-1:1);
    disp('Eigen decomposition done.');
    
    %% Train PCA -- Truncate
    if cutoff < 1
        I = cumsum(FullD)/sum(FullD);
        I = find(I>=cutoff);
        n_PCA_Reserved = I(1);
    else
        n_PCA_Reserved = cutoff;
    end
    V = FullV(:, 1:n_PCA_Reserved);
    D = FullD(1:n_PCA_Reserved);
    
    W_PCA = img_train * V;% ./ repmat(sqrt(D'), [size(img1_train,1), 1]);
    parfor i = 1 : size(W_PCA,2)
        W_PCA(:,i) = W_PCA(:,i) / sqrt(D(i));
    end
else
    C = img_train * img_train';
    [FullV, FullD] = eig(C);
    FullD = diag(FullD);
    FullD = FullD(end:-1:1);
    FullV = FullV(:, end:-1:1);
    disp('Eigen decomposition done.');
    %% Train PCA -- Truncate
    if cutoff < 1
        I = cumsum(FullD)/sum(FullD);
        I = find(I>=cutoff);
        n_PCA_Reserved = I(1);
    else
        n_PCA_Reserved = cutoff;
    end
    V = FullV(:, 1:n_PCA_Reserved);
    D = FullD(1:n_PCA_Reserved);
    
    W_PCA = V;   
end

%% Projection
img_train = W_PCA' * img_train;
img_gallery = W_PCA' * img_gallery;
img_probe = W_PCA' * img_probe;
disp('Projection done.');
