function P = expectation(mu,var,alpha,X)
    K = length(alpha);
    N = size(X,1);
    P = zeros(N,K);
    for i=1:N
        for j=1:K
            inv_var = var(:,:,j)^-1;
            P(i,j) = alpha(j)*exp(-1/2*(X(i,:)-mu(j,:))*inv_var*(X(i,:)-mu(j,:))')*det(inv_var)^0.5;
        end
    end
    P = P./sum(P,2);
end