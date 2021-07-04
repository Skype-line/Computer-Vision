function [map,peak] = meanshiftSeg(img)
    img = double(img);
    L = size(img,1)*size(img,2);
    X = [reshape(img(:,:,1),[],1),reshape(img(:,:,2),[],1),reshape(img(:,:,3),[],1)];
    radius = 5;
    for i=1:L
        new_peak = find_peak(X,X(i,:),radius);
        if i==1
            peak = new_peak;
            map(i) = i;
        else
            [min_dist, min_ID] = min(sqrt(sum((peak-new_peak).^2,2)));
            if min_dist < radius/2
                map(i) = min_ID;
            else
                peak = [peak;new_peak];
                map(i) = size(peak,1);
            end
        end
    end
    map = reshape(map,size(img,1),size(img,2));
    disp("peak number is:")
    disp(size(peak,1))
    
end