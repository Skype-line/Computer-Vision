% computes the shape context descriptors for a set of points
%
% Input:
%   X        - 2 x n matrix, set of points
%   nbBins_theta     - number of bins in the angular dimension
%   nbBins_r        - number of bins in the radial dimension
%   smallest_r     - the length of the smallest radius
%   biggest_r         - the length of the biggest radius
% Output:
%   d        - 1 x n cell, each element is smallest_r x nbBins_theta
function d = sc_compute(X,nbBins_theta,nbBins_r,smallest_r,biggest_r)
    X = X';
    % For increased robustness, implement the normalization of all radial distances by the
    % mean distance of the distances between all point pairs in the shape.
    mean_dist = mean2(sqrt(dist2(X,X)));
    min_r = log(smallest_r);
    max_r = log(biggest_r);
    range_r = linspace(min_r,max_r,nbBins_r);
    range_theta = linspace(-pi,pi,nbBins_theta);
    for i=1:size(X,1)
        disp = X-X(i,:);
        % transform to log-polar coordinate
        log_dist = log(sqrt(disp(:,1).^2+disp(:,2).^2)./mean_dist);
        theta = atan2(disp(:,2),disp(:,1));
        log_dist(i,:)=[];
        theta(i,:)=[];
        %Count number of points inside each bin
        d{i} = hist3([log_dist,theta],'Edges',{range_r,range_theta});
    end
end

