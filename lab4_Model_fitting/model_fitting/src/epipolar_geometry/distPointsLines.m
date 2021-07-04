% Compute the distance for pairs of points and lines
% Input
%   points    Homogeneous 2D points 3xN
%   lines     2D homogeneous line equation 3xN
% 
% Output
%   d         Distances from each point to the corresponding line N
function d = distPointsLines(points, lines)
    d = [];    
    for i=1:size(points,2)
            d = [d,abs(points(:,i)'*lines(:,i))/sqrt(lines(1,i)^2+lines(2,i)^2)];
    end
end

