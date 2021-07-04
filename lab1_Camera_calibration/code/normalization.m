%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn
% xy_normalized: 3xn
% XYZ_normalized: 4xn
% T: 3x3
% U: 4x4

function [xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ)
%data normalization
    N = size(xy,2);
% TODO 1. compute centroids
    c2D = mean(xy,2);
    c3D = mean(XYZ,2);
% TODO 2. shift the points to have the centroid at the origin
    xy_c = xy - c2D;
    XYZ_c = XYZ - c3D;
% TODO 3. compute scale
    s2D = sum(sqrt(sum(xy_c.^2,1)))/N;
    s3D = sum(sqrt(sum(XYZ_c.^2,1)))/N;
% TODO 4. create T and U transformation matrices (similarity transformation)
    T = inv([s2D 0 c2D(1); 0 s2D c2D(2); 0 0 1]);
    U = inv([s3D 0 0 c3D(1); 0 s3D 0 c3D(2); 0 0 s3D c3D(3); 0 0 0 1]);
% TODO 5. normalize the points according to the transformations
    xy_normalized = T*[xy;ones(1,N)];
    XYZ_normalized = U*[XYZ;ones(1,N)];
end