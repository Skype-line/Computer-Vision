% Compute the fundamental matrix using the eight point algorithm and RANSAC
% Input
%   x1, x2 	  Point correspondences 3xN
%   threshold     RANSAC threshold
%
% Output
%   best_inliers  Boolean inlier mask for the best model
%   best_F        Best fundamental matrix
%
function [best_inliers, best_F] = ransac8pF(x1, x2, threshold)

iter = 200000;

num_pts = size(x1, 2); % Total number of correspondences
best_num_inliers = 0; best_inliers = [];
best_ratio = 0;
p = 0.99;

for i=1:iter
    % Randomly select 8 points and estimate the fundamental matrix using these.
    SelectID = randperm(num_pts,8);
    [Fh,~] = fundamentalMatrix(x1(:,SelectID), x2(:,SelectID));
    % Compute the error.
    distances = (distPointsLines(x2,Fh*x1) + distPointsLines(x1,Fh'*x2))/2;
    % Compute the inliers with errors smaller than the threshold.
    inlrID = find(distances<threshold);
    % Update the number of inliers and fitting model if the current model
    % is better.
    num_inliers = size(inlrID,2);
    if num_inliers > best_num_inliers
        best_num_inliers = num_inliers;
        best_inliers = distances<threshold;
%         best_F = Fh;
        % adaptive ransac
        best_ratio = best_num_inliers/num_pts;
    end
    prob = 1-(1-best_ratio^8)^i;
    if (prob>p)
        fprintf("the value of M is:%d\n",i);
    	break;
    end
end
[best_F,~] = fundamentalMatrix(x1(:, best_inliers), x2(:, best_inliers));
% distances = (distPointsLines(x2,best_F*x1) + distPointsLines(x1,best_F'*x2))/2;
% fprintf("total inlier counts is: %d\n", best_num_inliers); 
% fprintf("best inlier ratio: %0.2f\n", best_ratio);
% fprintf("mean error of inliers: %0.2f\n", mean(distances(best_inliers)));

% end

end


