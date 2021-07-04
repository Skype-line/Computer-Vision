function [map, cluster] = EM(img)
    img = double(img);
    % Create the density function
    X = [reshape(img(:,:,1),[],1),reshape(img(:,:,2),[],1),reshape(img(:,:,3),[],1)];

    % use function generate_mu to initialize mus: K*3
    % use function generate_cov to initialize covariances: 3*3*K
    % K: number of segments
    K = 3;
    threshold = 1;
    % initialization
    mus = generate_mu(X, K);
    covariances = generate_cov(X, K);
    alphas = ones(K,1)*1/K;
    % iterate between maximization and expectation
    % use function maximization
    % use function expectation
    flag = 0;
    iter = 0;
    while flag ==0 
        P = expectation(mus,covariances,alphas,X);
        [new_mus, covariances, alphas] = maximization(P, X);
        flag = norm(new_mus-mus)<threshold;
        mus = new_mus;
        iter = iter+1;
    end
    fprintf("iteration number is %d\n",iter);
    [~,map] = max(P,[],2);
    map = reshape(map,size(img,1),size(img,2));
    cluster = mus;
    disp("alphas are")
    disp(alphas)
    disp("mus are")
    disp(mus)
    disp("covariances are")
    disp(covariances)
end