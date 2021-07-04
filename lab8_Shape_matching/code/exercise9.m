% =========================================================================
% Exercise 9
% =========================================================================
clc
close all
clear all

nsamp = 200;
data = load('dataset.mat');
data = data.objects;
% img1 = data(1).img;
% img2 = data(2).img;
% figure(1)
% subplot(1,2,1)
% imshow(img1)
% subplot(1,2,2)
% imshow(img2)
pts1 = data(1).X;
pts2 = data(2).X;
X = get_samples(pts1,nsamp);
Y = get_samples(pts2,nsamp);
matchingCost = shape_matching(X,Y,1);