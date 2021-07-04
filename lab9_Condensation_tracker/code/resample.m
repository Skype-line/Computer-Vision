function [particles,particles_w] = resample(particles,particles_w)
%resample the particles based on their weights
% Input:
%   particles     - estimated particles
%   particles_w   - weights of estimated particles
% Output:
%   particles     - resampled particles
%   particles_w   - weights of resampled particles
    N = size(particles,1);
    index = randi(N);
    beta = 0;
    Max = max(particles_w);
    resampled_particles = zeros(size(particles));
    resampled_w = zeros(size(particles_w));
    for i = 1:N
        beta = beta + rand() * 2*Max;
        while beta > particles_w(index)
            beta = beta - particles_w(index);
            index = mod(index+1, N)+1;
        end
        resampled_particles(i,:) = particles(index,:);
        resampled_w(i) = particles_w(index);
    end
    particles = resampled_particles;
    particles_w = resampled_w/sum(resampled_w);

end

