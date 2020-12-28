clear all
close all

load MDID.mat

pathDist = 'C:\Users\Public\QualityAssessment\MDID\distortion_images';
pathRef  = 'C:\Users\Public\QualityAssessment\MDID\reference_images';

S = dir(fullfile(pathDist, '*.bmp'));

numberOfImages = size(mos, 1);
Scores = zeros(numberOfImages, 1);
Features = zeros(numberOfImages, 132);

parfor i=1:numberOfImages
    if(mod(i,100)==0)
        disp(i);
    end
    F = fullfile(pathDist, S(i).name);
    refImgName = strcat(S(i).name(1:5), '.bmp');
    
    DistortedImg = imread(F);
    %ReferenceImg = imread(strcat(pathRef, filesep, refImgName));
    
    Features(i,:) = getFeatures(DistortedImg);
end

names = string(cell2mat(struct2cell(struct('name', {S(1:end).name}))));

PLCC = zeros(1,100); SROCC = zeros(1,100); KROCC = zeros(1,100);

parfor i=1:100
    disp(i);
    rng(i);
    [Train, Test] = splitTrainTest_MDID(names);

    TrainFeatures = Features(Train,:);
    TestFeatures  = Features(Test,:);
    
    YTest = (mos(Test))';
    YTrain= (mos(Train))';

    Mdl = fitrsvm(TrainFeatures, YTrain, 'KernelFunction', 'gaussian', 'KernelScale', 'auto', 'Standardize', true);
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
saveas(gcf,'MDID_Box.png');
