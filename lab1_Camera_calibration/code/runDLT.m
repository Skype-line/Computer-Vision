%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn 

function [P, K, R, t, error] = runDLT(xy, XYZ)

N = size(xy,2);
% normalize 
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);
% if no normalization, uncomment the following
% xy_normalized = [xy;ones(1,N)];
% XYZ_normalized = [XYZ;ones(1,N)];

%compute DLT with normalized coordinates
[Pn] = dlt(xy_normalized, XYZ_normalized);

% TODO denormalize projection matrix
P = T\Pn*U;
% if no normalization, uncomment the following
% P = Pn;
%factorize projection matrix into K, R and t
[K, R, t] = decompose(P);   

% TODO compute average reprojection error
XYZ_homogeneous=homogenization(XYZ);
xyz_projected=P*XYZ_homogeneous;
xy_projected=zeros(2,N);
for i=1:N
    xy_projected(1,i)=xyz_projected(1,i)./xyz_projected(3,i); % compute inhomogeneous coordinates x=x/z 
    xy_projected(2,i)=xyz_projected(2,i)./xyz_projected(3,i); % compute inhomogeneous coordinates y=y/z 
end
error = norm(xy-xy_projected,2)^2/N;
end