function [mu, var, alpha] = maximization(P, X)
    K = size(P,2);
    N = size(X,1);
    alpha = mean(P,1);
    mu = zeros(K,3);
    var = zeros(3,3,K);
    for i=1:K
        mu(i,:) = sum(X.*P(:,i),1)/(alpha(i)*N);
        for j=1:N
            var(:,:,i) = var(:,:,i)+P(j,i)*(X(j,:)-mu(i))'*(X(j,:)-mu(i));
        end
        var(:,:,i) = var(:,:,i)/(alpha(i)*N);
    end
end