%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%

function [K, R, t] = decompose(P)
%Decompose P into K, R and t using QR decomposition

% TODO Compute R, K with QR decomposition such M=K*R 
[invR,invK] = qr(inv(P(:,1:3)));
R = inv(invR);
K = inv(invK);

% TODO Compute camera center C=(cx,cy,cz) such P*C=0 
[~,~,V] = svd(P);
C = V(:,end);
C = C/C(4);

% TODO normalize K such K(3,3)=1
K = K/K(3,3);
% TODO Adjust matrices R and Q so that the diagonal elements of K (= intrinsic matrix) are non-negative values and R (= rotation matrix = orthogonal) has det(R)=1

T = diag(sign(diag(K,0)));
K = K*T;
R = T\R;
R = R * det(R);
% TODO Compute translation t=-R*C
t = -R*C(1:3);
end