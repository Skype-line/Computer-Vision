%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xyn: 3xn
% XYZn: 4xn

function [P_normalized] = dlt(xyn, XYZn)
%computes DLT, xy and XYZ should be normalized before calling this function
N = size(xyn,2);
% TODO 1. For each correspondence xi <-> Xi, computes matrix Ai
A = [];
for i=1:N
    A = [A;[XYZn(:,i).' zeros(1,4) -xyn(1,i)*XYZn(:,i).';
          zeros(1,4) -XYZn(:,i).' xyn(2,i)*XYZn(:,i).']];
end 
% TODO 2. Compute the Singular Value Decomposition of Usvd*S*V' = A
[U,S,V] = svd(A);
% TODO 3. Compute P_normalized (=last column of V if D = matrix with positive
% diagonal entries arranged in descending order)
Pn = V(:,end);
P_normalized = reshape(Pn,4,3);
P_normalized = P_normalized.';
end
