function [W, M] = PCATrain(img_train, nReserved)

M = mean(img_train,2);
img1_train = bsxfun(@minus, img_train, M);

C = img1_train'*img1_train;
[FullV, FullD] = eigs(C, size(img1_train,2), 'LM');
FullD = diag(FullD);

% Truncate
V = FullV(:, 1:nReserved);
D = FullD(1:nReserved);

W = img1_train * V;% ./ repmat(sqrt(D'), [size(img1_train,1), 1]);
for i = 1 : size(W,2)
    W(:,i) = W(:,i) / sqrt(D(i));
end

energy = sum(FullD(:));
fprintf('Trainning and projecting finished. nReserved = %d, Energy Percentage = %4.2f%%\n', nReserved, sum(D(:))/energy*100);
