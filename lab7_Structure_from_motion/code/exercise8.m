% =========================================================================
% Exercise 8
% =========================================================================

% Initialize VLFeat (http://www.vlfeat.org/)
% run('vlfeat-0.9.21/toolbox/vl_setup.m')
% addpath('GCMex-master')
% compilerCfg = mex.getCompilerConfigurations;
% compilerCfg(1).MexOpt = '/Users/kerry/Library/Application Support/MathWorks/MATLAB/R2019a/mex_C++_maci64.xml';
% compilerCfg(2).MexOpt = '/Users/kerry/Library/Application Support/MathWorks/MATLAB/R2019a/mex_C_maci64.xml';
% mex -setup C++
% mex -setup C
% run('/Users/kerry/Documents/study/CV/exercise/Lab Assignment - Structure from Motion-20201119/code_exercise/GCMex-master/compile_gc.m')
clc
close all
clear all
%set parameters
thresh_fundmatrix = 0.0001;
thresh_projmatrix = 0.05;
%K Matrix for house images (approx.)
K = [  670.0000     0     393.000
         0       670.0000 275.000
         0          0        1];

%Load images
imgName1 = '../data/house.000.pgm';
imgName2 = '../data/house.004.pgm';

img1 = single(imread(imgName1));
img2 = single(imread(imgName2));

%extract SIFT features and match
[fa, da] = vl_sift(img1);
[fb, db] = vl_sift(img2);

%don't take features at the top of the image - only background
filter = fa(2,:) > 100;
fa = fa(:,filter);
da = da(:,filter);

[matches, ~] = vl_ubcmatch(da, db);

x1 = fa(1:2, matches(1,:));
x2 = fb(1:2, matches(2,:));

% showFeatureMatches(img1, x1, img2, x2, 20);

%% Compute essential matrix and projection matrices and triangulate matched points

%use 8-point ransac or 5-point ransac - compute (you can also optimize it to get best possible results)
%and decompose the essential matrix and create the projection matrices
[F, inliers] = ransacfitfundmatrix(x1, x2, thresh_fundmatrix, 1);

outliers = setdiff(1:size(matches,2),inliers);
E = K'*F*K;
x1_in = x1(:,inliers);
x2_in = x2(:,inliers);
x1_out = x1(:,outliers);
x2_out = x2(:,outliers);

showInlierOutlier(img1, x1_in, x1_out, img2, x2_in, x2_out, 1);

%% draw Epipolar geometry of the initialization images
[U,~,V] = svd(F);
% compute epipoles
epipole1 = V(:,end);
epipole1 = epipole1/epipole1(3);
epipole2 = U(:,end);
epipole2 = epipole2/epipole2(3);
% show clicked points
figure(11),clf, imshow(img1, []); hold on, plot(x1_in(1,:), x1_in(2,:), '*r');
figure(21),clf, imshow(img2, []); hold on, plot(x2_in(1,:), x2_in(2,:), '*r');

% draw epipolar lines in img 1
figure(11)
plot(epipole1(1),epipole1(2),'or','LineWidth',2,'MarkerSize',10)
x1_in = makehomogeneous(x1_in);
x2_in = makehomogeneous(x2_in);
for k = 1:size(x1_in,2)
    drawEpipolarLines(F'*x2_in(:,k), img1);
end
% draw epipolar lines in img 2
figure(21)
plot(epipole2(1),epipole2(2),'or','LineWidth',2,'MarkerSize',10')
for k = 1:size(x2_in,2)
    drawEpipolarLines(F*x1_in(:,k), img2);
end

% transform from pixel coordinates to 3D camera coordinates 
x1_calibrated = K^(-1)*x1_in;
x2_calibrated = K^(-1)*x2_in;

Ps{1} = eye(4);
% decompose E to get projection matrice P
Ps{2} = decomposeE(E, x1_calibrated, x2_calibrated);

%triangulate the inlier matches to get 3D points with the computed projection matrix
[XS{1}, ~] = linearTriangulation(Ps{1}, x1_calibrated, Ps{2}, x2_calibrated);

%% Add an addtional view of the scene 

imgName3 = '../data/house.001.pgm';
img3 = single(imread(imgName3));
[fc, dc] = vl_sift(img3);
filter = fc(2,:) > 100;
fc = fc(:,filter);
dc = dc(:,filter);

% only use inliers of image1 to compute match
fa = fa(:,matches(1,inliers));
da = da(:,matches(1,inliers));
[matches, ~] = vl_ubcmatch(da, dc);

x1 = fa(1:2, matches(1,:));
x2 = fc(1:2, matches(2,:));

%run 6-point ransac to compute pose of the new image, use 3D-2D point correspondences
new_2D_pts = K^(-1)*makehomogeneous(x2);
old_3D_pts = XS{1}(:,matches(1,:));
[Ps{3}, inliers] = ransacfitprojmatrix(new_2D_pts, old_3D_pts, thresh_projmatrix, 1);
%avoid reflection transform
if det(Ps{3}(1:3,1:3))<0
    Ps{3}(1:3,:) = -Ps{3}(1:3,:);
end

outliers = setdiff(1:size(matches,2),inliers);
x1_in = x1(:,inliers);
x2_in = x2(:,inliers);
x1_out = x1(:,outliers);
x2_out = x2(:,outliers);

showInlierOutlier(img1, x1_in, x1_out, img3, x2_in, x2_out, 2);
%triangulate the inlier matches with the computed projection matrix
x1_calibrated = K^(-1)*makehomogeneous(x1_in);
x2_calibrated = K^(-1)*makehomogeneous(x2_in);
[XS{2}, ~] = linearTriangulation(Ps{1}, x1_calibrated, Ps{3}, x2_calibrated);

%% Add more views...
% just repeat the above operations
for i = 2:3
    new_imgName = join(['../data/house.00',int2str(i),'.pgm']);
    new_img = single(imread(new_imgName));
    [fnew, dnew] = vl_sift(new_img);
    filter = fnew(2,:) > 100;
    fnew = fnew(:,filter);
    dnew = dnew(:,filter);
    [matches, ~] = vl_ubcmatch(da, dnew);

    x1 = fa(1:2, matches(1,:));
    x2 = fnew(1:2, matches(2,:));

%     showFeatureMatches(img1, x1, img2, x2, 20);
    %run 6-point ransac
    new_2D_pts = K^(-1)*makehomogeneous(x2);
    old_3D_pts = XS{1}(:,matches(1,:));
    [Ps{i+2}, inliers] = ransacfitprojmatrix(new_2D_pts, old_3D_pts, thresh_projmatrix, 1);
    if det(Ps{i+2}(1:3,1:3))<0
        Ps{i+2}(1:3,:) = -Ps{i+2}(1:3,:);
    end
    
    outliers = setdiff(1:size(matches,2),inliers);
    x1_in = x1(:,inliers);
    x2_in = x2(:,inliers);
    x1_out = x1(:,outliers);
    x2_out = x2(:,outliers);

    showInlierOutlier(img1, x1_in, x1_out, new_img, x2_in, x2_out, i+1);
    %triangulate the inlier matches with the computed projection matrix
    x1_calibrated = K^(-1)*makehomogeneous(x1(:,inliers));
    x2_calibrated = K^(-1)*makehomogeneous(x2(:,inliers));
    [XS{i+1}, ~] = linearTriangulation(Ps{1}, x1_calibrated, Ps{i+2}, x2_calibrated);
end

%% Plot stuff

fig = 10;
figure(fig);

%use plot3 to plot the triangulated 3D points
colors = {'r','g','b','y'};
for i =1:4
    plot3(XS{i}(1,:),XS{i}(2,:),XS{i}(3,:),join(['.',colors{i}]))
    hold on
end
%draw cameras
drawCameras(Ps, fig);

%% Dense reconstruction
scale = 0.5^2;
imgL = imresize(img1, scale);
imgR = imresize(img3, scale);

[imgRectL, imgRectR, Hleft, Hright, maskL, maskR] = ...
    getRectifiedImages(imgL, imgR);
figure(5);
subplot(121); imshow(imgRectL);
subplot(122); imshow(imgRectR);
%%
% Set disparity range
% (exercise 5.3)
% you may use the following lines
% to get a good guess
clickPoints = 0;
Method = 2;
if Method == 1
    cacheFile = 'images/clickedpoints.mat';
    if (clickPoints)
        [x1s, x2s] = getClickedPoints(imgRectL, imgRectR);
        save(cacheFile, 'x1s', 'x2s', '-mat');
    else
        load('-mat', cacheFile, 'x1s', 'x2s');
    end
    x1s = x1s(1:2,:);
    x2s = x2s(1:2,:);
elseif Method==2
%     Method 2: using sift features
    imgL = single(imgRectL);
    imgR = single(imgRectR);
    
    % extract SIFT features and match
    [fa, da] = vl_sift(imgL); % keypoints and descriptors 
    [fb, db] = vl_sift(imgR);
    [matches, scores] = vl_ubcmatch(da, db);
    
    x1s = [fa(1:2, matches(1,:)); ones(1,size(matches,2))];
    x2s = [fb(1:2, matches(2,:)); ones(1,size(matches,2))];
    
    % adaptive ransac8pF
    threshold = 2;
    [inliers, F] = ransac8pF(x1s, x2s, threshold);
    x1s = x1s(1:2, inliers);
    x2s = x2s(1:2, inliers);
end

% showFeatureMatches(imgRectL, x1s, imgRectR, x2s, 1);
HB = quantile(x1s(1,:)-x2s(1,:),0.99);
LB = quantile(x1s(1,:)-x2s(1,:),0.01);
Bound = ceil(max(abs(HB),abs(LB)));
dispRange = -Bound:Bound;
%%
% % Compute disparities using graphcut
% % (exercise 5.2)
Labels = ...
    gcDisparity(imgRectL, imgRectR, dispRange);
dispsGCL = double(Labels + dispRange(1));
Labels = ...
    gcDisparity(imgRectR, imgRectL, dispRange);
dispsGCR = double(Labels + dispRange(1));

figure(6);
subplot(121); imshow(dispsGCL, [dispRange(1) dispRange(end)]);
subplot(122); imshow(dispsGCR, [dispRange(1) dispRange(end)]);
%%
% S = [scale 0 0; 0 scale 0; 0 0 1];
% 
% % For each pixel (x,y), compute the corresponding 3D point 
% % use S for computing the rescaled points with the projection 
% % matrices PL PR
% PL = K*Ps{1};
% PR = K*Ps{3};
% [coords ~] = ...
%     generatePointCloudFromDisps(dispsGCL, Hleft, Hright, S*PL, S*PR);
% % ... same for other winner-takes-all
% [coords2 ~] = ...
%     generatePointCloudFromDisps(dispStereoL, Hleft, Hright, S*PL, S*PR);

%% transform disparity map to depth map
f = K(1,1); % focal length
B = norm(Ps{3}-Ps{1}); % baseline length
depth = B*f./dispsGCL;
imgRectL = cat(3,imgRectL,imgRectL,imgRectL);
create3DModel(depth,imgRectL,8);
