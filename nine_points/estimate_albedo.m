% Function of the main program

function [g, f_hat] = estimate_albedo(I, n, s_est, f_avg, sigma_f_sq, sigma_err, nTs_est_thresh);

% Calculate noisy albedo g(i,j) = h(i,j) / n(i,j)^T * s_est

I_thresh = 0;

[g, null_flag, nTs_est] = calc_noisy_p(I, n, s_est, nTs_est_thresh, I_thresh);
% *************************************************************************

% Calculate w(i,j)

nTs_est_mod = nTs_est .* (1 - null_flag) + null_flag;
nTs_est_mod_sq = nTs_est_mod .* nTs_est_mod;
%sigma_1_sq = repmat(0.01, [r,c]) ./ nTs_est_mod_sq;
sigma_1_sq = 0.3 * sigma_err ./ nTs_est_mod_sq;
sigma_1_sq = sigma_1_sq .* (1 - null_flag);

% *************************************************************************
% Calculate sigma_w_sq
sigma_w_sq =sigma_1_sq .*  (sigma_f_sq + f_avg .* f_avg);
% *************************************************************************

% Calculate w(i,j)
w = sigma_f_sq ./ (sigma_f_sq + sigma_w_sq);

% *************************************************************************
% Linear Combination
f_hat = (1 - w) .* f_avg + w .* g;

%f_hat(null_flag==1) = f_avg(null_flag==1);

return;

