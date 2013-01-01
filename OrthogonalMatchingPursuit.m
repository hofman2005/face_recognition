function [x, res] = OrthogonalMatchingPursuit(y, D, sparsity)

if ~exist('sparsity', 'var') || sparsity == size(D, 2)  % The simple case
    x = pinv(D) * y;
    res = y - D * x;
else  % The normal OMP algorithm
    x = zeros(size(D,2), 1);
    res = y;
    atom_set = [];
    
    for i = 1 : sparsity
        c = res' * D;
        err = bsxfun(@minus, bsxfun(@times, D, c), res);
        err = sqrt(sum(err.^2, 1));
        
        [~, I] = min(err);
        atom_set = cat(2, atom_set, I);
        xx = pinv(D(:, atom_set)) * y;
        res = y - D(:, atom_set) * xx;
    end
    
    for i = 1 : length(atom_set)
        x(atom_set(i)) = xx(i);
    end
end