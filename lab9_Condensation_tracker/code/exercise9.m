load('../data/params.mat');
params.model=1;
params.alpha=0.5;
params.num_particles=500;
% params.hist_bin=30;
% params.sigma_observe = 1;
params.sigma_position=30;
% params.sigma_velocity=3;
params.initial_velocity=[-50 10];
disp(params)
videoName = 'crosswalk';
condensationTracker(videoName,params)