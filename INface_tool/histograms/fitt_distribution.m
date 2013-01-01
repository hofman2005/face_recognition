% The function fitts a predefined distribution to the histogram of an image
% 
% PROTOTYPE
% Yy=fitt_distribution(X,distr,param);
% 
% USAGE EXAMPLE(S)
% 
%     Example 1:
%       X=imread('sample_image.bmp');
%       Y=fitt_distribution(X);
%       figure,imshow(X);
%       figure,imshow(Y,[]);
% 
%     Example 2:
%       X=imread('sample_image.bmp');
%       Y=fitt_distribution(X,2);
%       figure,imshow(X);
%       figure,imshow(Y,[]);
% 
%     Example 3:
%       X=imread('sample_image.bmp');
%       Y=fitt_distribution(X,2,[0 0.2]);
%       figure,imshow(X);
%       figure,imshow(Y,[]);
% 
%     Example 4:
%       X=imread('sample_image.bmp');
%       Y=fitt_distribution(X,3,0.005);
%       figure,imshow(X);
%       figure,imshow(Y,[]);
% 
%
%
% GENERAL DESCRIPTION
% The function fitts a predefined distribution to the histogram of an
% image. This means that after the procedure the histogram looks like a
% distribution with the selected parameters. Actully, only the standard
% deviation (for the normal and lognormal distributions)is considered as 
% the mean is adjusted once the image is scaled back to the 8-bit interval. 
% This funcion is an alternative to histogram equalization (which strictly 
% speaking does nothing more than fitting a uniform distribution to the 
% image). While histogram equalization in most cases increases the
% background noise the remapping might not. Therefore it may be usefull in
% some cases to use this function for image enhancement rather than
% histogram equalization and use the enhanced image as input to face
% rcognition. Currently three different target distributions are supported,
% the normal, lognormal and exponential distribution, one can easily extend
% the function to support other ditributions as well by adding options to
% matlabs build-in icdf function. 
% 
%
%
% 
% REFERENCES
% This function is an implementation of histogram remapping for which a
% more detailed descriptions can be found in:
%
% Štruc, V., Žibert, J. in Pavešiæ, N.: Histogram remapping as a
% preprocessing step for robust face recognition, WSEAS transactions on 
% information science and applications, vol. 6, no. 3, pp. 520-529, 2009.
% (BibTex available from:
% http://luks.fe.uni-lj.si/sl/osebje/vitomir/pub/WSEAS.bib)
%
%
%
% INPUTS:
% X                     - a grey-scale image of arbitrary size
% distr                 - a scalar value determining the target
%                         distribution, valid options are
%                           1   - the target distribution is normal (default)
%                           2   - the target distribution is lognormal
%                           3   - the target distribution is exponential
% param                 - a vector or scalar determining the parameters of
%                         the target distribution, for the implemented
%                         target distributions:
%                           normal      - [mean,std], e.g. [0,1] (default)
%                           lognormal   - [mean,std], e.g. [0,0.2] (default)
%                           exponential - [labmda], e.g. [1] (default)
% 
%
% OUTPUTS:
% Y                     - a grey-scale image with a remapped histogram
%                         
%
% NOTES / COMMENTS
% This function applies histogram remapping to the
% grey-scale image X. 
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
% 1. Štruc V., Pavešiæ, N.:Performance Evaluation of Photometric Normalization 
% Techniques for Illumination Invariant Face Recognition, in: Y.J. Zhang (Ed), 
% Advances in Face Image Analysis: Techniques and Technologies, IGI Global, 
% 2010.      
% 
% 
%
% Copyright (c) 2009 Vitomir Štruc
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
function Yy=fitt_distribution(X,distr,param);

%% Parameter check
Yy=0; % dummy
if nargin ==1 
    distr = 1;
    param = [0 1];
elseif nargin == 2
    if distr == 1 
        param = [0 1];
    elseif distr == 2 
        param = [0 0.2];    
    elseif distr == 3
        param = 1;
    else
        param=1;
    end
elseif nargin >3
    disp('Error! Wrong number of input parameters.')
    return;
end

if distr == 1 || distr == 2
    [a,b]=size(param);
    if a ~=1 || b~=2
        disp('The normal and lognormal distributions require two parameters in the parameter vector (size: 1 x 2).')
    end    
elseif distr == 3
    [a,b]=size(param);
    if a ~=1 || b ~= 1
        disp('The exponential distribution requires one and only one parameter.')
    end
else
    disp('Wrong value for parameter "distr".')
    return
end

%% Init. operations
[a,b]=size(X);
X=normalize8(X);
n=a*b;

%% Fitt distribution
if distr == 1
    R=rank_normalization(X(:), 'two','descend')';
    left = (n+0.5-(R))/n;
    Yy=norminv(left,param(1,1),param(1,2));
elseif distr ==2
    R=rank_normalization(X(:), 'two','descend')';
    left = (n+0.5-(R))/n;
    Yy=icdf('Lognormal',left,param(1,1),param(1,2));
elseif distr ==3
    R=rank_normalization(X(:), 'two','ascend')';
    left = (n+0.5-(R))/n;
    Yy=icdf('exp',left,param(1,1));
    Yy = 255-normalize8(Yy);
end
Yy = normalize8(reshape(Yy,[a,b]));


