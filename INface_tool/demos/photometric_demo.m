% A demo script showing the application of the photometric normalization techniques on a sample image.
% 
% GENERAL DESCRIPTION
% The script applies all normalization techniques of the INface toolbox to 
% a sample image and displays the results in a figure. 
% 
% 
%
% NOTES / COMMENTS
% The script was tested with Matlab ver. 7.5.0.342 (R2007b) and WindowsXP.
% 
% ABOUT
% Created:        28.8.2009
% Last Update:    28.8.2009
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


%% Load sample image
disp(sprintf('This is a Demo script for the INface toolbox. It applies all of the \nphotometric normalization techniques contained in the toolbox to a sample \nimage and displays the estimated reflectance (illumination invariant) part \nof the image in a figure.\n'))
X=imread('sample_image.bmp');
X=normalize8(imresize(X,[128,128],'bilinear'));

%% Prepare figure - reflectance
figure(1)
subplot(4,4,1)
imshow(normalize8(X),[])
hold on 
axis image
axis off
title('Original')


%% Apply the photometric normalization techniques

%SSR
disp('Applying the single scale retinex technique.')
Y=single_scale_retinex(X); %reflectance

%display the images
figure(1)
subplot(4,4,2)
imshow(normalize8(Y),[])
title('SSR')
disp('Done.')

%MSR
disp('Applying the mutli scale retinex technique.')
Y=multi_scale_retinex(X); %reflectance

%display the images
figure(1)
subplot(4,4,3)
imshow(normalize8(Y),[])
title('MSR')
disp('Done.')


%ASR
disp('Applying the adaptive single scale retinex technique.')
siz = [3 5 11 15];
sigma = [0.9 0.9 0.9 0.9];
Y=adaptive_single_scale_retinex(X); %reflectance

%display the images
figure(1)
subplot(4,4,4)
imshow(normalize8(Y),[])
title('ASR')
disp('Done.')


%HOMO
disp('Applying homomorphic filtering.')
Y=homomorphic(X); %reflectance

%display the images
figure(1)
subplot(4,4,5)
imshow(normalize8(Y),[])
title('HOMO')
disp('Done.')


%SSQ
disp('Applying the single scale self quotient image technique.')
Y=single_scale_self_quotient_image(X); %reflectance

%display the images
figure(1)
subplot(4,4,6)
imshow(normalize8(Y),[])
title('SSQ')
disp('Done.')



%MSQ
disp('Applying the multi scale self quotient image technique.')
Y=multi_scale_self_quotient_image(X); %reflectance

%display the images
figure(1)
subplot(4,4,7)
imshow(normalize8(Y),[])
title('MSQ')
disp('Done.')


%DCT
disp('Applying the DCT-based normalization technique.')
Y=DCT_normalization(X); %reflectance

%display the images
figure(1)
subplot(4,4,8)
imshow(normalize8(Y),[])
title('DCT')
disp('Done.')



%WA
disp('Applying the wavelet-based normalization technique.')
Y=wavelet_normalization(X); %reflectance

%display the images
figure(1)
subplot(4,4,9)
imshow(normalize8(Y),[])
title('WA')
disp('Done.')


%WD
disp('Applying the wavelet-denoising-based normalization technique.')
Y=wavelet_denoising(X,'coif1',3); %reflectance

%display the images
figure(1)
subplot(4,4,10)
imshow(normalize8(Y),[])
title('WD')
disp('Done.')


%IS
disp('Applying the isotropic diffusion-based normalization technique.')
Y=isotropic_smoothing(X); %reflectance

%display the images
figure(1)
subplot(4,4,11)
imshow(normalize8(Y),[])
title('IS')
disp('Done.')


%AS
disp('Applying the anisotropic diffusion-based normalization technique.')
Y=anisotropic_smoothing(X); %reflectance

%display the images
figure(1)
subplot(4,4,12)
imshow(normalize8(Y),[])
title('AS')
disp('Done.')


%NLM
disp('Applying the non-local-means-based normalization technique.')
Y=nl_means_normalization(X); %reflectance

%display the images
figure(1)
subplot(4,4,13)
imshow(normalize8(Y),[])
title('NLM')
disp('Done.')


%ANL
disp('Applying the adaptive non-local-means-based normalization technique.')
Y=adaptive_nl_means_normalization(X); %reflectance

%display the images
figure(1)
subplot(4,4,14)
imshow(normalize8(Y),[])
title('ANL')
disp('Done.')


%SF
disp('Applying the steerable filter based normalization technique.')
Y = steerable_gaussians(X); %reflectance

%display the images
figure(1)
subplot(4,4,15)
imshow(normalize8(Y),[])
title('SF')
disp('Done.')























