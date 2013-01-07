function [out,m] = myquantizer(in, N)

%% Histogram
% a = in(:) - min(in(:));
% a = a * 255 / (max(a)-min(a));
% c = histc(a, [-0.5:254.5]);

%% Solve quantizer
% e = -eps : 255/N : 255;
% m = zeros(N,1);
% flag = 1;
% while flag
%     olde = e;
%     for i = 1 : length(e)-1
%         index = ceil(e(i)+eps) : floor(e(i+1));
%         m(i) = index * c(index+1) / sum(c(index+1));
%         if sum(c(index+1)) == 0
%             m(i) = mean(index);
%         end
%     end
%     for i = 1 : length(e)-2
%         e(i+1) = (m(i+1)+m(i))/2;
%     end
%     if sum((olde-e).^2) < 1e-5
%         flag = 0;
%     end
% end

%% Solve quantizer
flag = 1;
m = zeros(N, 1);
a = in(:);
e = min(a) : (max(a)-min(a)) / N : max(a)*(1+eps);
while flag
    olde = e;
    for i = 1 : length(e)-1
        m(i) = mean( a( a>=e(i) & a<(e(i+1)) ) );
        if size(a( a>=e(i) & a<(e(i+1)) ),1) == 0
            m(i) = (e(i)+e(i+1))/2;
        end
    end
    for i = 1 : length(e)-2
        e(i+1) = (m(i) + m(i+1)) / 2;
    end
    if sum((olde-e).^2) < eps
        flag = 0;
    end
end

%%
out = zeros(size(in));
for i = 1 : length(e)-1
    out( in>=e(i) & in<(e(i+1)) ) = m(i);
end