function meanState = estimate(particles,particles_w)
%estimate the mean state given the particles and their weights
    meanState = sum(particles.*repmat(particles_w,1,size(particles,2)),1);
end

