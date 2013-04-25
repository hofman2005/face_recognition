% DFR Testing
% 
% Author:       Tao Wu
% Email:        taowu@umiacs.umd.edu
% Last update:  11/12/2010

function [label, dist] = mp_test(img, Dict)

addpath(genpath(pwd));

D = Dict.D;
pinvD = Dict.pinvD;

% Distance calculator
dist = zeros(size(img,2), numel(D));
for j = 1 : size(img,2)
    for i = 1 : numel(D)
        [feature, res] = project(img(:,j), D{i}, pinvD{i});
        dist(j,i) = sum(res.^2);
    end
end
[Y,I] = sort(dist,2);

label = I(:,1);


function [feature res] = project(img, D, pinvD)
feature = pinvD*img;
res = sum((img-D*feature).^2);
