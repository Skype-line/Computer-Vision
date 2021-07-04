function particles_w = observe(particles,frame,H,W,hist_bin,hist_target,sigma_observe)
%make observations and use observations to update weights
    particles_w = zeros(size(particles,1),1);
    for i=1:size(particles,1)
        hist = color_histogram(particles(i,1)-0.5*W,particles(i,2)-0.5*H,particles(i,1)+0.5*W,particles(i,2)+0.5*H,frame,hist_bin);
        particles_w(i) = 1/(sqrt(2*pi)*sigma_observe)*exp(-chi2_cost(hist, hist_target)^2/(2*sigma_observe^2));
    end
    particles_w = particles_w/sum(particles_w);
end

