% Extract descriptors.
%
% Input:
%   img           - the gray scale image
%   keypoints     - detected keypoints in a 2 x q matrix
%   
% Output:
%   keypoints     - 2 x q' matrix
%   descriptors   - w x q' matrix, stores for each keypoint a
%                   descriptor. w is the size of the image patch,
%                   represented as vector
function [keypoints, descriptors] = extractDescriptors(img, keypoints)
 mask = (keypoints>4) & bsxfun(@lt,keypoints,size(img)'-[4;4]);
 keypoints = keypoints(:,mask(1,:) & mask(2,:));
 descriptors = extractPatches(img,keypoints,9);
end