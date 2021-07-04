% Extract Harris corners.
%
% Input:
%   img           - n x m gray scale image
%   sigma         - smoothing Gaussian sigma
%                   suggested values: .5, 1, 2
%   k             - Harris response function constant
%                   suggested interval: [4e-2, 6e-2]
%   thresh        - scalar value to threshold corner strength
%                   suggested interval: [1e-6, 1e-4]
%   
% Output:
%   corners       - 2 x q matrix storing the keypoint positions
%   C             - n x m gray scale image storing the corner strength
function [corners, C] = extractHarris(img, sigma, k, thresh)
Ix = conv2(img,[1 0 -1],'same')/2;
Iy =  conv2(img,[1 0 -1]','same')/2;
Ixx = imgaussfilt(Ix.^2,sigma);
Ixy = imgaussfilt(Ix.*Iy,sigma);
Iyy = imgaussfilt(Iy.^2,sigma);
[W,L] = size(img);
C = zeros([W, L]);
for i=1:W
    for j=1:L
        M = [Ixx(i,j),Ixy(i,j);Ixy(i,j),Iyy(i,j)];
        C(i,j) = det(M)-k * trace(M)^2;
    end
end
[I,J] = find(C>thresh & imregionalmax(C));
corners = [I';J'];
end