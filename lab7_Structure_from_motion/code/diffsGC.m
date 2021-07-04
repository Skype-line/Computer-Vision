function diffs = diffsGC(img1, img2, dispRange)

% get data costs for graph cut
    diffs = zeros(size(img1,1),size(img1,2),size(dispRange,2));
    window = 3;
    H = fspecial('average',window);
    i = 1;
    for d = dispRange
        img2shift = shiftImage(img2, d);
        diff = (img2shift-img1).^2;
        diffs(:,:,i) = conv2(diff,H,'same');
        i = i+1;
    end
end