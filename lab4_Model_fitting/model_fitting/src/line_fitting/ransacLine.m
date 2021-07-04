function [best_k, best_b] = ransacLine(data, iter, threshold)
% data: a 2xn dataset with n data points
% iter: the number of iterations
% threshold: the threshold of the distances between points and the fitting line

num_pts = size(data, 2); % Total number of points
best_num_inliers = 0;   % Best fitting line with largest number of inliers
best_k = 0; best_b = 0;     % parameters for best fitting line

for i=1:iter
    % Randomly select 2 points and fit line to these
    % Tip: Matlab command randperm / randsample is useful here
    SelectID = randperm(num_pts,2);
    SelectP = data(:,SelectID);
    
    % Model is y = k*x + b. You can ignore vertical lines for the purpose
    % of simplicity.
    k = (SelectP(2,2)-SelectP(2,1))/(SelectP(1,2)-SelectP(1,1));
    b = SelectP(2,2)-k*SelectP(1,2);
    
    % Compute the distances between all points with the fitting line
    n = [k -1]; 
    n = n/norm(n);
    pt1 = [0;b];
    distances = abs(n*(data-pt1*ones(1,num_pts)));
    
    % Compute the inliers with distances smaller than the threshold
    inlrID = find(distances<threshold);
    
    % Update the number of inliers and fitting model if the current model
    % is better.
    num_inliers = size(inlrID,2);
    if num_inliers > best_num_inliers
        pts = data(:,inlrID);
        coef = polyfit(pts(1,:), pts(2,:), 1);
        best_k = coef(1);
        best_b = coef(2);
        best_num_inliers = num_inliers;
    end
end


end
