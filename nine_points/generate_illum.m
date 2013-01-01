function nine_img=generate_illum(I);

InputImage = double(I);
[r c] = size(InputImage);

% *************************************************************************
% Load vetters data and compute the albedo and normal avg and statistics
% *************************************************************************
load vetters_data;

% load JTW_front;
% 
% % Compute f_ensemble and sigma_f_sq from vetters data
% 
% Jf = reshape(Jf, 125, 125, 100);
% Jf = imresize(Jf(27:80, 35:91, :), [48, 40], 'bicubic');
% for i = 1 : 100
%     Jf(:,:,i) = Jf(:,:,i) * 255 / max(max(Jf(:,:,i)));
% end;
% 
% f_ensemble = mean(Jf, 3);
% f_ensemble = f_ensemble * 255 / max(f_ensemble(:));
% Jf_centered = Jf - repmat(f_ensemble,[1,1,100]);
% sigma_f_sq = sum((Jf_centered .* Jf_centered), 3) / 100;
% 
% % *************************************************************************
% 
% % Get n_avg from vetters data
% 
% Tf = reshape(Tf, 125, 125, 300);
% Tf = imresize(Tf(27:80, 35:91, :), [48 40], 'bicubic');
% 
% Tfx = Tf(:, :, 1:3:end);
% Tfy = Tf(:, :, 2:3:end);
% Tfz = Tf(:, :, 3:3:end);
% 
% [g1, g2, g3] = size(Tf);
% n_avg = zeros(g1, g2, 3);
% n_avg(:, :, 1) = mean(Tfx, 3);
% n_avg(:, :, 2) = mean(Tfy, 3);
% n_avg(:, :, 3) = mean(Tfz, 3);
% 
% for i = 1 : g1
% 	for j = 1 : g2
% 		n_avg(i, j, :) = n_avg(i, j, :)/norm(squeeze(n_avg(i, j, :)));
% 	end
% end
% *************************************************************************

% Get sigma_err 
sigma_s_sq = repmat(0.01, [r,c]);
% 
% Tfx_centered = Tfx - repmat(n_avg(:, :, 1),[1,1,100]);
% sigma_Tfx_sq = sum((Tfx_centered .* Tfx_centered), 3) / 100;
% 
% Tfy_centered = Tfy - repmat(n_avg(:, :, 2),[1,1,100]);
% sigma_Tfy_sq = sum((Tfy_centered .* Tfy_centered), 3) / 100;
% 
% Tfz_centered = Tfz - repmat(n_avg(:, :, 3),[1,1,100]);
% sigma_Tfz_sq = sum((Tfz_centered .* Tfz_centered), 3) / 100;
% 
% sigma_n_sq = 0.5*(sigma_Tfx_sq + sigma_Tfy_sq + sigma_Tfz_sq)/3;

sigma_err = sigma_s_sq + sigma_n_sq;

% *************************************************************************
% Estimate source direction

s_est = estimate_source_horn(double(InputImage), n_avg);
s_est = s_est/norm(s_est);

% Estimate albedo
nts_Thresh = 0.0005;
[noisy_p, p_est] = estimate_albedo(double(InputImage), n_avg, s_est, f_ensemble, sigma_f_sq, sigma_err, nts_Thresh);

% th=(pi/180)*[0, 68, 74, 80, 85, 85, 85, 85, 51]; %orig
% phi=(pi/180)*[0,-90,108,52,-42,-137,146,-4,67]; %orig
% phi=(pi/180)*[0, 49, -68, 73, 77, -84, -84, 82, -50]; %soma
th=(pi/180)*[0,10, 0, -18, 37, 47, -47, -56, -84]; %soma
phi=(pi/180)*[0, 20, -68, 73, 77, -84, -84, 82, -50];
for k=1:9
    [x,y,z]=sph2cart(th(k),phi(k),1);
    s=[x,y,z];
    for i = 1 : r
        for j = 1 : c
            img(i,j) = max(dot(squeeze(n_avg(i,j,:)),s), 0.005);
        end
    end

    nine_img(:,:,k)=p_est.*img;
end

return;

