function D_new = ink_svd(D)

%% Remove those identical atoms.
G = abs(D'*D - eye(size(D,2)));
G = triu(G);
[I, J] = find(G>=0.999);
D(:, unique(J)) = [];

D_new = D;
mu = mutual_coherence(D);
mu_target = 1 / sqrt( size(D,1) );

while mu > mu_target + 1e-5
    % Partition
    E = partition(D_new, mu_target);
    % Decorrelate
    for i = 1 : size(E,1)
        [x1, x2] = decoorelate(D_new(:,E(i,1)), D_new(:,E(i,2)), mu_target);
        D_new(:,E(i,1)) = x1;
        D_new(:,E(i,2)) = x2;
    end
    
    mu = mutual_coherence(D_new);
    fprintf('mu: %f\r', mu);
end


%% Mutual coherence
function mu = mutual_coherence(D)
mu = D'*D - eye(size(D,2));
mu = max(abs(mu(:)));

%% Partition
function E = partition(D, mu)
G = abs(D'*D - eye(size(D,2)));
G = triu(G);
E = [];

[Y,I] = max(G(:));
% while Y > mu
%     [x,y] = ind2sub(size(G), I);
%     E = cat(1, E, [x,y]);
%     G = G([1:x-1,x+1:end], [1:y-1,y+1:end]);
%     [Y,I] = max(G(:));
% end

[x,y] = ind2sub(size(G), I);
E = [x,y];

%% Decoorelate
function [x1, x2] = decoorelate(y1, y2, mu)
u1 = y1 + y2;
u2 = y1 - y2;

u1 = u1 / norm(u1);
u2 = u2 / norm(u2);

theta = 1/2 * acos(mu);

x1 = cos(theta)*u1 + sin(theta)*u2;
x2 = cos(theta)*u1 - sin(theta)*u2;