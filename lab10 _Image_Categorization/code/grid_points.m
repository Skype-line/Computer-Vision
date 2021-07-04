function vPoints = grid_points(img,nPointsX,nPointsY,border)
%Implement a very simple local feature point detector: points on a grid.
% Input:
% border: leave out # of pixels in each image dimension
% nPointsX/nPointsY: # of grid in x/y dimensions
% Output:
% vPoints: [nPointsX*nPointsY,2] grid points
    [h, w] = size(img);
    [X, Y] = meshgrid(int32(linspace(border+1,w-border,nPointsX)),int32(linspace(border+1,h-border,nPointsY)));
    vPoints = [reshape(X,[],1),reshape(Y,[],1)];
end
