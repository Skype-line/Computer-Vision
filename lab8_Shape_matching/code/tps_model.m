%use Thin Plate Splines model f to estimate a plane tranformation T(x, y) = (fx(x, y), fy(x, y))
% 
% Input:
%   X        -  n x 2 matrix, points in the template shape
%   Y        -  n x 2 matrix, corresponding points in the target shape
%   lambda   - regularization parameter
% Output:
%   w_x        - parameters (wi and ai) in the TPS model of x coordinate
%   w_y        - parameters (wi and ai) in the TPS model of y coordinate
%   E          - total bending energy E=w'Kw
%   
function [w_x,w_y,E] = tps_model(X,Y,lambda)
    nbSamples = size(X,1);
    dist = max(dist2(X,X),0);
    K = dist.*log(dist+eps);
    P = [ones(nbSamples,1),X];
    A = [[K+lambda*eye(nbSamples),P];[P',zeros(3)]];
    bx = [Y(:,1);zeros(3,1)];
    by = [Y(:,2);zeros(3,1)];
    w_x = A\bx;
    w_y = A\by;
    E = w_x(1:nbSamples)'*K*w_x(1:nbSamples) + w_y(1:nbSamples)'*K*w_y(1:nbSamples);
end

