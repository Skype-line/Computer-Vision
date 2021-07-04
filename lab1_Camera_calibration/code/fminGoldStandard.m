%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy_normalized: 3xn
% XYZ_normalized: 4xn

function f = fminGoldStandard(pn, xy_normalized, XYZ_normalized)

%reassemble P
P = [pn(1:4);pn(5:8);pn(9:12)];

% TODO compute reprojection errors
xyz_projected=P*XYZ_normalized;
N=size(xy_normalized,2);
xy_projected=zeros(2,N);
for i=1:N
    xy_projected(1,i)=xyz_projected(1,i)./xyz_projected(3,i); % compute inhomogeneous coordinates x=x/z 
    xy_projected(2,i)=xyz_projected(2,i)./xyz_projected(3,i); % compute inhomogeneous coordinates y=y/z 
end
error = norm(xy_normalized(1:2,:)-xy_projected,2);
% TODO compute cost function value
f = error^2/N;
end