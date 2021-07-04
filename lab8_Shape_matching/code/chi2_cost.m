%computes a cost matrix between two sets of shape context descriptors
% 
% Input:
%   s1        -  1 x n cell, shape context descriptors of template shape
%   s2     -  1 x n cell, shape context descriptors of target shape
% Output:
%   C        - n x n matrix, shape matching costs
function C = chi2_cost(s1,s2)
    dim1 = size(s1,2);
    dim2 = size(s2,2);
    C = zeros(dim1,dim2);
    for i=1:dim1
        for j=1:dim2
            cost = (s1{i}-s2{j}).^2./(s1{i}+s2{j});
            cost(isnan(cost))=0;
            C(i,j)=0.5*sum(cost,'all');
        end
    end
end

