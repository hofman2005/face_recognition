function X = projection_dict(D, Y, K)

%% Quick method
% Assuming the colums of D are normalized.
X = pinv(D) * Y;

%% Standard method
