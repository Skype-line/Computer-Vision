% =========================================================================
% Fundamental matrix
% =========================================================================
clear
addpath helpers

clickPoints = false;
%dataset = 0;   % Your pictures
% dataset = 1; % ladybug
dataset = 2; % rect
% dataset = 3; % pumpkin


% image names
if(dataset==0)
    imgName1 = ''; % Add your own images here if you want
    imgName2 = '';
elseif(dataset==1)
    imgName1 = 'images/ladybug_Rectified_0768x1024_00000064_Cam0.png';
    imgName2 = 'images/ladybug_Rectified_0768x1024_00000080_Cam0.png';
elseif(dataset==2)
    imgName1 = 'images/rect1.jpg';
    imgName2 = 'images/rect2.jpg';
elseif(dataset==3)
    imgName1 = 'images/pumpkin1.jpg';
    imgName2 = 'images/pumpkin2.jpg';
end

% read in images
img1 = im2double(imread(imgName1));
img2 = im2double(imread(imgName2));

[pathstr1, name1] = fileparts(imgName1);
[pathstr2, name2] = fileparts(imgName2);

% You can save the points so you don't need to click every time
cacheFile = [pathstr1 filesep 'matches_' name1 '_vs_' name2 '.mat'];

% get point correspondences
if (clickPoints)
    [x1s, x2s] = getClickedPoints(img1, img2);
    save(cacheFile, 'x1s', 'x2s', '-mat');
else
    load('-mat', cacheFile, 'x1s', 'x2s');
end

%% estimate fundamental matrix

[Fh, F] = fundamentalMatrix(x1s, x2s); % TODO: implement this function
Fh
F

%% Draw epipolar lines

% FF is the fundamental matrix we wish to draw epipolar lines for
FF = Fh;
[U,~,V] = svd(FF);
% FF = F
% compute epipoles
epipole1 = V(:,end);
epipole1 = epipole1/epipole1(3);
epipole2 = U(:,end);
epipole2 = epipole2/epipole2(3);

% show clicked points
figure(1),clf, imshow(img1, []); hold on, plot(x1s(1,:), x1s(2,:), '*r');
figure(2),clf, imshow(img2, []); hold on, plot(x2s(1,:), x2s(2,:), '*r');

% draw epipolar lines in img 1
figure(1)
plot(epipole1(1),epipole1(2),'or','LineWidth',2,'MarkerSize',10)
for k = 1:size(x1s,2)
    drawEpipolarLines(FF'*x2s(:,k), img1);
end
% draw epipolar lines in img 2
figure(2)
plot(epipole2(1),epipole2(2),'or','LineWidth',2,'MarkerSize',10')
for k = 1:size(x2s,2)
    drawEpipolarLines(FF*x1s(:,k), img2);
end
