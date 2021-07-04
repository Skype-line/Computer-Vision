function hist = color_histogram(xMin,yMin,xMax,yMax,frame,hist_bin)
%calculate the normalized histogram of RGB colors occurring within 
%the bounding box defined by [xMin, xMax]X[yMin, yMax] within the current video frame.
    xMin = max(1,round(xMin));
    yMin = max(1,round(yMin));
    xMax = min(size(frame,2),round(xMax));
    yMax = min(size(frame,1),round(yMax));
    bbox = frame(yMin:yMax,xMin:xMax,:);
    [cnt_R,~] = imhist(bbox(:,:,1),hist_bin);
    [cnt_G,~] = imhist(bbox(:,:,2),hist_bin);
    [cnt_B,~] = imhist(bbox(:,:,3),hist_bin);
    hist = [cnt_R;cnt_G;cnt_B];
    hist = hist/sum(hist,'all');
end

