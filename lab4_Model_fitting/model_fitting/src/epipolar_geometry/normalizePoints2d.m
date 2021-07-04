% Normalization of 2d-pts
% Inputs: 
%           xs = 2d points
% Outputs:
%           nxs = normalized points
%           T = 3x3 normalization matrix
%               (s.t. nx=T*x when x is in homogenous coords)
function [nxs, T] = normalizePoints2d(xs)
    % subtract the mean and divide by the standard deviation.
    mxs = mean(xs,2);
    stdx = std(xs(1,:),1);
    stdy = std(xs(2,:),1);
    T = [1/stdx, 0, -mxs(1)/stdx;
         0, 1/stdy, -mxs(2)/stdy;
         0, 0,              1    ];
    nxs = T*xs;
end
