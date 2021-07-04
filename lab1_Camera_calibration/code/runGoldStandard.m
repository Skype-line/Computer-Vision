%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn 

function [P, K, R, t, error] = runGoldStandard(xy, XYZ)

%normalize data points
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

%compute DLT with normalized coordinates
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

%minimize geometric error to refine P_normalized
% TODO fill the gaps in fminGoldstandard.m
pn = [P_normalized(1,:) P_normalized(2,:) P_normalized(3,:)];
for i=1:20
    [pn] = fminsearch(@fminGoldStandard, pn, [], xy_normalized, XYZ_normalized);
end

% TODO: denormalize projection matrix
Pn = [pn(1:4);pn(5:8);pn(9:12)];
P = T\Pn*U;

%factorize prokection matrix into K, R and t
[K, R, t] = decompose(P);

% TODO compute average reprojection error
N=size(xy_normalized,2);
XYZ_homogeneous=homogenization(XYZ);
xyz_projected=P*XYZ_homogeneous;
xy_projected=zeros(2,N);
for i=1:N
    xy_projected(1,i)=xyz_projected(1,i)./xyz_projected(3,i); % compute inhomogeneous coordinates x=x/z 
    xy_projected(2,i)=xyz_projected(2,i)./xyz_projected(3,i); % compute inhomogeneous coordinates y=y/z 
end
error = norm(xy-xy_projected,2)^2/N;
end