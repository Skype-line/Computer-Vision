function peak = find_peak(X,xl,r)
%find the mode of the density function for a given pixel xl
%Input
%   X    - Lxn matrix, discrete samples of the density function
%   xl   - n, one pixel
%   r    - radius of spherical window
%Output
%   peak - n, mode
    old_mean = xl;
    flag = 1;
    while flag>=1
        distances = sum((X-old_mean).^2,2);
        inliers = X(distances<r^2,:);
        new_mean = mean(inliers,1);
        flag = norm(new_mean-old_mean);
        old_mean = new_mean;
    end
    peak = new_mean;
end

