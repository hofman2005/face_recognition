function [dist] = identify(img, D, pinvD)

% Distance calculator
dist = zeros(numel(D), 1);
for i = 1 : numel(D)
    [feature res] = project(img, D{i}, pinvD{i});
    dist(i) = sum(res.^2);
end

%%
function [feature res] = project(img, D, pinvD)
feature = pinvD*img;
res = sum((img-D*feature).^2);