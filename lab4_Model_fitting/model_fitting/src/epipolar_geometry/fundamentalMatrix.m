% Compute the fundamental matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences 3xN
%
% Output
% 	Fh 		Fundamental matrix with the det F = 0 constraint
% 	F 		Initial fundamental matrix obtained from the eight point algorithm
%
function [Fh, F] = fundamentalMatrix(x1s, x2s)
    [nx1s, T1] = normalizePoints2d(x1s);
    [nx2s, T2] = normalizePoints2d(x2s);
    %construct big data matrix A (x1x1',x1y1',x1,y1x1',y1y1',y1,x1',y1',1; x2....)
    A =[bsxfun(@times,nx1s(1,:),nx2s); 
        bsxfun(@times,nx1s(2,:),nx2s); 
        bsxfun(@times,nx1s(3,:),nx2s)]';
    
    % A * vec(F) = 0
    [~,~,V] = svd(A);
    nF = reshape(V(:,end),3,3);
    
    % remove normalization
    F = T2'*nF*T1;
    % enforce sigularity constraint def(Fh)=0
    [U,S,V] = svd(F);
    S(3,3) = 0;
    Fh = U*S*V';
end