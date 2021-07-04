function label = bow_recognition_bayes( histogram, vBoWPos, vBoWNeg)


[muPos, sigmaPos] = computeMeanStd(vBoWPos);
[muNeg, sigmaNeg] = computeMeanStd(vBoWNeg);

% Calculating the probability of appearance each word in observed histogram
% according to normal distribution in each of the positive and negative bag of words
ProbPos = normpdf(histogram,muPos,sigmaPos);
ProbPos(isnan(ProbPos))=1;
ProbPos = exp(sum(log(ProbPos),2));
ProbNeg = normpdf(histogram,muNeg,sigmaNeg);
ProbNeg(isnan(ProbNeg))=1;
ProbNeg = exp(sum(log(ProbNeg),2));
label = double(ProbPos>ProbNeg);
end