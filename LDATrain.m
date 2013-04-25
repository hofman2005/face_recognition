function W_LDA = LDATrain(img_train, index_train)

% LDA Train
Sb = 0;
M = mean(img_train, 2);
for i = 1 : size(img_train, 2)
    x = (img_train(:, i) - M);
    Sb = Sb + x*x';
    fprintf('Computing Sb i=%d\n',i);
end
Sb = Sb / size(img_train,2);

Sw = 0;
for i = 1 : max(index_train)
    index = find(index_train==i);
    M = mean(img_train(:, index), 2);
    sw = 0;
    for m = 1 : size(index,1)
        x = (img_train(:, index(m))-M);
        sw = sw + x*x';
    end
    Sw = Sw + sw*2 / size(index,1);
    fprintf('Computing Sw i=%d\n',i);
end

% [V,D] = eigs(inv(Sw)*(Sw+Sb), size(Sb,1)-1, 'LM');
% W2 = V(:, 1:LDA_Reserved);

LDA_Reserved = min(size(img_train,1) - 1,  max(index_train) - 1);

[V,D] = eigs(Sb, Sw+1*eye(size(Sw,1)), size(Sb,1)-1, 'LM');
W_LDA = V(:, 1:LDA_Reserved);

disp('LDA finished');
