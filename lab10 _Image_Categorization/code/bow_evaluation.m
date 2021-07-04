%
% BAG OF WORDS RECOGNITION EXERCISE
% Alex Mansfield and Bogdan Alexe, HS 2011
% Denys Rozumnyi, HS 2019

%training
% disp('creating codebook');
close all
clear all
clc
NN_Accuracy = [];
Bayes_Accuracy = [];
% k = [25,50,75,100,125,150,175,200,225,250];
k = 200;
for sizeCodebook = k
    disp(strcat('  The number of cluster centres is: ', num2str(sizeCodebook)));
    NN_Accuracy_k = [];
    Bayes_Accuracy_k = [];
%     for i = 1:10 % for robust testing
    for i = 1:1 % for visualization
        disp(strcat('  Run epoch ', num2str(i),'...'));
        vCenters = create_codebook('../data/cars-training-pos','../data/cars-training-neg',sizeCodebook);
%         vCenters = create_codebook('../data/dogs-training-pos','../data/dogs-training-neg',sizeCodebook);
        %keyboard;
        disp('processing positve training images');
        vBoWPos = create_bow_histograms('../data/cars-training-pos',vCenters);
%         vBoWPos = create_bow_histograms('../data/dogs-training-pos',vCenters);
        disp('processing negative training images');
        vBoWNeg = create_bow_histograms('../data/cars-training-neg',vCenters);
%         vBoWNeg = create_bow_histograms('../data/dogs-training-neg',vCenters);
        %vBoWPos_test = vBoWPos;
        %vBoWNeg_test = vBoWNeg;
        %keyboard;
        disp('processing positve testing images');
        vBoWPos_test = create_bow_histograms('../data/cars-testing-pos',vCenters);
%         vBoWPos_test = create_bow_histograms('../data/dogs-testing-pos',vCenters);
        disp('processing negative testing images');
        vBoWNeg_test = create_bow_histograms('../data/cars-testing-neg',vCenters);
%         vBoWNeg_test = create_bow_histograms('../data/dogs-testing-neg',vCenters);

        nrPos = size(vBoWPos_test,1);
        nrNeg = size(vBoWNeg_test,1);

        test_histograms = [vBoWPos_test;vBoWNeg_test];
        labels = [ones(nrPos,1);zeros(nrNeg,1)];

        disp('______________________________________')
        disp('Nearest Neighbor classifier')
        NN_accuracy = bow_recognition_multi(test_histograms, labels, vBoWPos, vBoWNeg, @bow_recognition_nearest);
        NN_Accuracy_k = [NN_Accuracy_k,NN_accuracy];
        disp('______________________________________')
        disp('Bayesian classifier')
        Bayes_accuracy = bow_recognition_multi(test_histograms, labels, vBoWPos, vBoWNeg, @bow_recognition_bayes);
        Bayes_Accuracy_k = [Bayes_Accuracy_k,Bayes_accuracy];
        disp('______________________________________')
    end
    disp('______________________________________')
    disp('Nearest Neighbor classifier')
    disp(['Percentage of correctly classified images:' num2str(mean(NN_Accuracy_k))]);
    NN_Accuracy = [NN_Accuracy,mean(NN_Accuracy_k)];
    disp('______________________________________')
    disp('Bayesian classifier')
    disp(['Percentage of correctly classified images:' num2str(mean(Bayes_Accuracy_k))]);
    Bayes_Accuracy = [Bayes_Accuracy,mean(Bayes_Accuracy_k)];
    disp('______________________________________')
end
% %%
% figure(20)
% plot(k,NN_Accuracy,'LineWidth',2)
% hold on
% plot(k,Bayes_Accuracy,'LineWidth',2)
% xlabel('size of cookbook')
% ylabel('accuracy')
% % ylim([0.8,1])
% grid on
% legend('Nearest Neighbor classifier','Bayesian classifier')
