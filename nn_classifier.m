function nn_classifier(img_gallery, index_gallery, img_probe, index_probe)

%% Euclidean Distance Matrix
ED = zeros(size(img_probe,2), size(img_gallery,2));
for i = 1 : size(img_probe, 2)
%     Dist = img_gallery - repmat(img_probe(i, :), [size(img_gallery,1),1]);
%     Dist = sum(Dist.^2,2);
%     ED(i,:) = sqrt(Dist');
    Dist = img_gallery' * img_probe(:,i) ./ norm(img_probe(:,i));
    Dist = acos(Dist' ./ sqrt(sum(img_gallery.^2,1)));
    ED(i,:) = Dist;
end
% disp('Euclidean Distance Matrix finished');
[Y,Index] = sort(ED, 2, 'ascend');
nRank = 152;
Accuracy = zeros(nRank, 1);
for rank = 1 : nRank
    Correct = ones(size(img_probe, 2),1);
    for i = 1 : rank
        res = index_gallery(Index(:,i));
        Correct = Correct .* (~(res==index_probe));
    end
    Accuracy(rank) = (size(Correct,1)-sum(Correct))/size(Correct,1);
end
figure(1);plot(1:nRank, Accuracy);title('CMS - Euclidean Distance');
cmc = Accuracy;
Accuracy = sum(index_gallery(Index(:,1)) == index_probe) / size(img_probe, 2);


