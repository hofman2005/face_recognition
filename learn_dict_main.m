function D = learn_dict_main(Y, N)

% Init
D = rand(size(Y,1), N);
K = 10;

% Solve
for i = 1 : 10
    fprintf('.');
    X = projection_dict(D, Y, K);
%     D_new = learn_dict(Y, D, X);

    % Learn
    for j = 1 : size(D, 2)
    end
end
fprintf('\n');