function histo = bow_histogram(vFeatures, vCenters)
  % input:
  %   vFeatures: MxD matrix containing M feature vectors of dim. D
  %   vCenters : NxD matrix containing N cluster centers of dim. D
  % output:
  %   histo    : N-dim. vector containing the resulting BoW
  %              activation histogram.
  
  
  % Match all features to the codebook and record the activated
  % codebook entries in the activation histogram "histo".
histo = zeros(1,size(vCenters,1));
for i = 1:size(vFeatures,1)
    % count matching features
    [~, matching] = min(sum((vFeatures(i,:)-vCenters).^2,2));
    histo(matching) = histo(matching)+1;
end
end
