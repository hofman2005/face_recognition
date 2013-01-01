% Function to calculate noisy albedo
% Input: I, n; Output: p_noisy

function[p_noisy, null_flag, nTs_est] = calc_noisy_p(I, n, s_est, nTs_est_thresh, I_thresh)

[r c] = size(I);

% *************************************************************************
% Calculate nTs_est
nTs_est = zeros(size(I));

for i = 1 : r
	for j = 1 : c
        	nTs_est(i,j) = max(dot(squeeze(n(i,j,:)),s_est), 0);
	end
end

% *************************************************************************

% Calculate p_noisy

null_flag = (((nTs_est <= nTs_est_thresh) + (I <= I_thresh)) > 0);

nTs_est_mod = nTs_est .* (1 - null_flag) + null_flag;

p_noisy = I ./ nTs_est_mod;
p_noisy = p_noisy .* (1 - null_flag);

return;