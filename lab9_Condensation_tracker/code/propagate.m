function particles = propagate(particles,sizeFrame,params)
%propagate the particles given the system prediction model (matrix A) 
%and the system model noise represented by params.model,
%params.sigma position and params.sigma velocity

%Input:
%   particles	- posterior state of all particles
%   sizeFrame	- size of each frame
%   params      - parameters structure
%Output:
%   particles	- priori/estimated state of all particles
if params.model==0 %still
    noise = normrnd(0,params.sigma_position,params.num_particles,2);
    particles = particles*eye(2)+noise;
    %Use the parameter sizeFrame to make sure that the center of the particle lies inside the frame.
    particles = max(min(particles,[sizeFrame(2),sizeFrame(1)]),[1,1]);
else % constant velocity
    noise1 = normrnd(0,params.sigma_position,params.num_particles,2);
    noise2 = normrnd(0,params.sigma_velocity,params.num_particles,2);
    A=[eye(2),eye(2);zeros(2),eye(2)];
    particles = particles*A'+[noise1,noise2];
    %Use the parameter sizeFrame to make sure that the center of the particle lies inside the frame.
    particles(:,1:2) = max(min(particles(:,1:2),[sizeFrame(2),sizeFrame(1)]),[1,1]);
end

