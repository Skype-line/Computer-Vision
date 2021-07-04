function [descriptors,patches] = descriptors_hog(img,vPoints,cellWidth,cellHeight)
% describe all features (grid points) by local descriptors
% Input:
    % vPoints: [nPointsX*nPointsY,2] feature points
    % cellWidth: width of each cell
    % cellHeight: height of each cell
% Output:
    % descriptors: #vPointsx128 feature descriptors
    % patches: #vPointsx(16*16) image patch spanned by 4*4 cells, each cell
    % contains 4*4 pixels
    nBins = 8;
    nCellsW = 4; % number of cells, hard coded so that descriptor dimension is 128
    nCellsH = 4; 
    angles = linspace(-pi,pi,nBins+1);
    w = cellWidth; % set cell dimensions
    h = cellHeight;   

    pw = w*nCellsW; % patch dimensions
    ph = h*nCellsH; % patch dimensions

    descriptors = zeros(size(vPoints,1),nBins*nCellsW*nCellsH); % one histogram for each of the 16 cells
    patches = zeros(size(vPoints,1),pw*ph); % image patches stored in rows    
    
    [grad_x,grad_y] = gradient(img);    
    Gdir = (atan2(grad_y, grad_x)); 
    
    for i = 1:size(vPoints,1) % for all local feature points
        vx = vPoints(i,1)-nCellsW/2*w;
        vy = vPoints(i,2)-nCellsH/2*h;
        patches(i,:) = reshape(img(vy:vy+nCellsH*h-1,vx:vx+nCellsW*w-1),[],1);
        index = 1;
        for j = vx:w:vx+(nCellsW-1)*w
            for k = vy:h:vy+(nCellsH-1)*h
                cell = Gdir(k:k+h-1,j:j+w-1);
                [histogram,~] = histcounts(cell,angles);
                descriptors(i,(index-1)*nBins+1:index*nBins) = histogram;
                index = index+1;
            end
        end  
    end % for all local feature points
end
