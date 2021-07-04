function disp = stereoDisparity(img1, img2, dispRange)

% dispRange: range of possible disparity values
% --> not all values need to be checked
img1 = double(img1);
img2 = double(img2);
disp = zeros(size(img1));
window = 15;
H = fspecial('average',window);
best_diff = 100000*ones(size(img1));
for d = dispRange
    img2shift = shiftImage(img2, d);

    % compute SSD
    diff = (img2shift-img1).^2;
    % compute SAD
%     diff = abs(img2shift-img1);

    new_diff = conv2(diff,H,'same');
    disp(new_diff<best_diff)=d;
    best_diff = min(best_diff,new_diff);
end
end