% Generate initial values for mu
% K is the number of segments

function mu = generate_mu(X, K)
 % mu: K*3, initialize to spread equally in the L*a*b* space.
    L_min = min(X(:,1));
    L_max = max(X(:,1));
    a_min = min(X(:,2));
    a_max = max(X(:,2));
    b_min = min(X(:,3));
    b_max = max(X(:,3));
    mu = [linspace(L_min,L_max,K)', linspace(a_min,a_max,K)', linspace(b_min,b_max,K)'];
end