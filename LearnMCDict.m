function [D, Dq, X, W] = LearnMCDict(Y, Yq, labels, max_num_atoms, sparsity)

% Parameters
% max_num_atoms = 50;
% sparsity = 10;
lambda = 1;
gamma = 5000;
max_iter = 10;

% Verify the input
if size(Y,1) ~= size(Yq,1) || size(Y,2) ~= size(Yq,2) || size(Y,2) ~= length(labels)
    error('The sizes of inputs do not match.');
end

% Build matrix H for supervised training.
% Assuming the labels begin with 1
H = zeros(max(labels), size(Y, 2));
for i = 1 : length(labels)
    H(labels(i), i) = 1;
end

% Initalize
D = rand(size(Y,1), max_num_atoms);
% D = Y(:, 1:max_num_atoms);
for i = 1 : size(D,2)
    D(:,i) = D(:,i) / norm(D(:,i));
end
Dq = rand(size(Y,1), max_num_atoms);
for i = 1 : size(Dq,2)
    Dq(:,i) = Dq(:,i) / norm(Dq(:,i));
end

%% Main loop

% Update D
X = zeros(size(D,2), size(Y,2));

% Update X after the update of a atom
% for iter = 1 : max_iter
%     dirt_dict = 1;
%     for k = 1 : size(D, 2)
%         if dirt_dict == 1
%             total_res = 0;
%             parfor i = 1 : size(Y,2)
%                 [x, res] = OrthogonalMatchingPursuit(Y(:,i), D, sparsity);
%                 X(:,i) = x;
%                 total_res = total_res + norm(res);
%             end
%             dirt_dict = 0;
%         end
%         %     fprintf('Iteration %d, total_res %f\n', k, total_res);
%         
%         xk = X(k, :);
%         
%         if xk*xk' < 1e-10
%             continue;
%         end
%         
%         Dk = D(:, [1:k-1, k+1:end]);
%         Ek = Y - Dk * X([1:k-1, k+1:end], :);
%         
%         dk = pinv( (xk*xk') * eye(size(Dk,1)) + lambda * (Dk * Dk') ) * Ek * xk';
% %         dk = 1/(xk*xk') * Ek * xk';
%         
%         dk = dk / norm(dk);
%         
%         D(:, k) = dk;
%         
%         dirt_dict = 1;
%     end
% end

% Update X after all atoms are updated
for iter = 1 : max_iter
    fprintf('Iteration %d\n', iter);
    fprintf('Sparse coding ...\n');
    total_res = 0;
    if sparsity == size(D, 2)
        X = pinv(D) * Y;
        res = Y - D * X;
        total_res = norm(res);
    else
        parfor i = 1 : size(Y,2)
            [x, res] = OrthogonalMatchingPursuit(Y(:,i), D, sparsity);
            X(:,i) = x;
            total_res = total_res + norm(res);
        end
    end
    fprintf('Total_res %f\n', total_res);
    
    fprintf('Updating atoms .. \n');
    for k = 1 : size(D, 2)
        
        xk = X(k, :);
        
        if xk*xk' < 1e-10
            continue;
        end
        
        sample_index = find(xk~=0);
        xk = xk(sample_index);
        atom_index = [1:k-1, k+1:size(D,2)];
        
        Dk = D(:, atom_index);
        Xk = X(atom_index, sample_index);
        Yk = Y(:, sample_index);
        Ek = Yk - Dk * Xk;
        
%         dk = pinv( (xk*xk') * eye(size(Dk,1)) + lambda * (Dk * Dk') ) * Ek * xk';
        dk = 1/(xk*xk') * Ek * xk';
        
        dk = dk / norm(dk);
        
        D(:, k) = dk;        
    end
    
    % Update Dq
    
    % Update X
    
end

% Update W
fprintf('Updating W...\n');
W = H * X' * pinv(X*X' + gamma * eye(size(X,1)));

