function D_new = learn_dict(Y, D_init, X)

% lambda = 3;
% D_new = fminunc(@(x) ObjFunc(Y, x, X, lambda), D_init);
% 
% function cost = ObjFunc(Y, D, X, lambda)
% 
% cost1 = Y - D*X;
% cost2 = D'*D - eye(size(D,2));
% 
% cost = norm(cost1) + lambda * norm(cost2);