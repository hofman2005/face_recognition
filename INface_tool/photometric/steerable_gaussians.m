% The function normalizes an image using steerable derivatives of gaussians
% 
% PROTOTYPE
% [Y] = steerable_gaussians(X1,sigmas,angles);
% 
% USAGE EXAMPLE(S)
% 
%     Example 1:
%       X=imread('sample_image.bmp');
%       Y = steerable_gaussians(X);
%       figure,imshow(X);
%       figure,imshow(uint8(Y),[]);
% 
%     Example 2:
%       X=imread('sample_image.bmp');
%       Y = steerable_gaussians(X,[0.1,1,3]);
%       figure,imshow(X);
%       figure,imshow(uint8(Y),[]);
% 
%     Example 3:
%       X=imread('sample_image.bmp');
%       Y = steerable_gaussians(X,[0.5,2],6);
%       figure,imshow(X);
%       figure,imshow(uint8(Y),[]);
% 
%
%
% GENERAL DESCRIPTION
% The function performs photometric normalization of the image X using
% steerable derivatives of gaussians. While these are normally used for 
% detecting edges in images, they can be employed to produce some kind of 
% illumination invariant represenatation of an image- similarly, as the 
% images gradient. This function supports applying steerable gaussians of
% several scales and orientations to be applied to an image. This means
% that it supports the mulsti as well as the single scale variant of the
% normalization.
% 
% The function is intended for use in face recognition experiments and the
% default parameters are set in such a way that a "good" normalization is
% achieved for images of size 128 x 128 pixels. Of course the term "good" is
% relative.
%
%
%
%
% INPUTS:
% X                     - a grey-scale image of arbitrary size
% sigmas                - a vector of size 1 x n, where n is the number of 
%                         filter scales, i.e., the parameter "sigma"
%                         actually controls the scale of the filter, if
%                         sigma is a scalar the normalization is performed
%                         for a single scale; default value "sigmas = 0.5"
% angles                - a scalar value that defines the angular
%                         resolution of the filters, e.g., if a value of 8
%                         is selected the filters are constructed for 8
%                         angles equally drawn from 1-180� or 0-pp, default
%                         value "angles=8".
% 
%
% OUTPUTS:
% Y                     - a grey-scale image processed with the technique
%                         
%
% NOTES / COMMENTS
% This function applies a normalization technique to the
% grey-scale image X using steerable derivates of gaussians. 
%
% The function was tested with Matlab ver. 7.5.0.342 (R2007b).
%
% 
% RELATED FUNCTIONS (SEE ALSO)
% normalize8    - auxilary function
% 
% ABOUT
% Created:        26.8.2009
% Last Update:    26.8.2009
% Revision:       1.0
% 
%
% WHEN PUBLISHING A PAPER AS A RESULT OF RESEARCH CONDUCTED BY USING THIS CODE
% OR ANY PART OF IT, MAKE A REFERENCE TO THE FOLLOWING PUBLICATIONS:
%
% 1. �truc V., Pave�i�, N.:Performance Evaluation of Photometric Normalization 
% Techniques for Illumination Invariant Face Recognition, in: Y.J. Zhang (Ed), 
% Advances in Face Image Analysis: Techniques and Technologies, IGI Global, 
% 2010.      
% 
% 2. �truc, V., �ibert, J. in Pave�i�, N.: Histogram remapping as a
% preprocessing step for robust face recognition, WSEAS transactions on 
% information science and applications, vol. 6, no. 3, pp. 520-529, 2009.
% (BibTex available from: http://luks.fe.uni-lj.si/sl/osebje/vitomir/pub/WSEAS.bib)
% 
%
% Copyright (c) 2009 Vitomir �truc
% Faculty of Electrical Engineering,
% University of Ljubljana, Slovenia
% http://luks.fe.uni-lj.si/en/staff/vitomir/index.html
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files, to deal
% in the Software without restriction, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in 
% all copies or substantial portions of the Software.
%
% The Software is provided "as is", without warranty of any kind.
% 
% August 2009

function [Y] = steerable_gaussians(X1,sigmas,angles);

%% Parameter checking
Y=0;%dummy
if nargin == 1
    sigmas = 0.5;
    angles = 8;
elseif nargin == 2
    angles = 8;
elseif nargin >3
    disp('Error! Wrong number of input parameters.')
    return;
end

%% Init. operations
[a,b]=size(X1);
X1=normalize8(log(double(X1)+1));

%% Construct steerable Gaussians
angle_step = pi/angles;
for i=1:length(sigmas)
    %construct filter support
    Wx = floor((7/2)*sigmas(1,i)); 
    if Wx < 1
       Wx = 1;
    end

    Wy = floor((7/2)*sigmas(1,i)); 
    if Wy < 1
       Wy = 1;
    end
    [X,Y]=meshgrid(-Wy:Wy,-Wx:Wx);

    %build base filters
    Gx = -2.*X.*exp(-(X.^2+Y.^2)./(2*sigmas(1,i)^2));
    Gy = -2.*Y.*exp(-(X.^2+Y.^2)./(2*sigmas(1,i)^2));
    
    %produce final filters
    for j=1:angles
       angle = (j-1)*angle_step;
       G{i,j}=cos(angle)*Gx+sin(angle)*Gy;      
    end  
end

%% Perform filtering
Y=zeros(a,b);
for i=1:length(sigmas) %scale
    tmp = zeros(a,b);
    for j=1:angles-1     %orientation
        tmp = tmp + (imfilter(X1,G{i,j},'replicate','same')); 
    end
    Y=Y+normalize8(tmp);
end
Y=normalize8(Y);


























