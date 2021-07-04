% show feature matches between two images
%
% Input:
%   img1        - n x m color image 
%   corner1     - 2 x k matrix, holding keypoint coordinates of first image
%   img2        - n x m color image 
%   corner1     - 2 x k matrix, holding keypoint coordinates of second image
%   fig         - figure id
function showInlierOutlier(img1, inlier1, outlier1, img2, inlier2, outlier2, fig)
    [~, sy, ~] = size(img1);
    img = [img1, img2];
    
    inlier2 = inlier2 + repmat([sy, 0]', [1, size(inlier2, 2)]);
    outlier2 = outlier2 + repmat([sy, 0]', [1, size(outlier2, 2)]);
    
    figure(fig), imshow(img, []);    
    hold on, plot(inlier1(1,:), inlier1(2,:), '+r');
    hold on, plot(outlier1(1,:), outlier1(2,:), '+r');
    hold on, plot(inlier2(1,:), inlier2(2,:), '+r');
    hold on, plot(outlier2(1,:), outlier2(2,:), '+r');  
    hold on, plot([inlier1(1,:); inlier2(1,:)], [inlier1(2,:); inlier2(2,:)], 'b'); 
    hold on, plot([outlier1(1,:); outlier2(1,:)], [outlier1(2,:); outlier2(2,:)], 'g');
end