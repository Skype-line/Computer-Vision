% Generate initial values for the K
% covariance matrices

function cov = generate_cov(X, K)
 % cov: 3*3*K, each initialized as a diagonal matrix with elements 
 % corresponding to the range of the L*, a* and b* values
    L_range = range(X(:,1));
    a_range = range(X(:,2));
    b_range = range(X(:,3));
    cov = zeros(3,3,K);
    for i=1:K
        cov(:,:,i) = diag([L_range,a_range,b_range]);
    end
end