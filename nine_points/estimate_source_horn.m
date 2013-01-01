% Estimate the source (assuming 1 source) by Horn's Method
% Input: I, n;   Output: s_est

function[s_est] = estimate_source_horn(I, n)

term1 = 0;
term2 = 0;
[row col ] = size(I);

for i=1:row
    for j=1:col
        %if(I(i,j) ~= 0)
            
            nij = squeeze(n(i,j,:));
            term1 = term1 + nij * nij';
            term2 = term2 + I(i,j) * nij;
            
            %end;
    end
end

s_est = inv(term1) * term2;
s_est = s_est/norm(s_est);

return;
