i = 560;
subplot(1,2,1),imshow(reshape(img_probe(:,i), [48,48]), []);
subplot(1,2,2),imshow(reshape(img_probe_recover(:,i), [48,48]), []);