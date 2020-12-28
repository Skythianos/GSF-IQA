clear all
close all

load KADID_Data2.mat % This mat file contains the names of images and MOS values

path = 'C:\Users\Public\QualityAssessment\KADID-10k\images'; % KADID-10k images (available: http://database.mmsp-kn.de/kadid-10k-database.html )

numberOfImages = size(dmos, 1);
Scores = zeros(numberOfImages, 1);
Features = zeros(numberOfImages, 132);

parfor i=1:numberOfImages
    if(mod(i,1000)==0)
        disp(i);
    end
    imgDist  = imread( char(strcat(path, filesep, string(dist_img(i)))) );
    %imgRef   = imread( char(strcat(path, filesep, string(ref_img(i)))) );
    Features(i,:) = getFeatures(imgDist);
end

PLCC = zeros(1,100); SROCC = zeros(1,100); KROCC = zeros(1,100);

parfor i=1:100
    rng(i);
    disp(i);
    [Train, Test] = splitTrainTest(dist_img);

    TrainFeatures = Features(Train,:);
    TestFeatures  = Features(Test,:);    
   
    YTest = dmos(Test);
    YTrain= dmos(Train);

    Mdl = fitrgp(TrainFeatures, YTrain, 'KernelFunction', 'rationalquadratic', 'Standardize', true);
    Pred= predict(Mdl,TestFeatures);
    
    eval = metric_evaluation(Pred, YTest);
    PLCC(i) = eval(1);
    SROCC(i)= eval(2);
    KROCC(i)= eval(3);
end

disp('----------------------------------');
X = ['Average PLCC after 100 random train-test splits: ', num2str(round(mean(PLCC(:)),3))];
disp(X);
X = ['Average SROCC after 100 random train-test splits: ', num2str(round(mean(SROCC(:)),3))];
disp(X);
X = ['Average KROCC after 100 random train-test splits: ', num2str(round(mean(KROCC(:)),3))];
disp(X);

figure;boxplot([PLCC',SROCC',KROCC'],{'PLCC','SROCC','KROCC'});
saveas(gcf,'KADID_Box.png');
        
