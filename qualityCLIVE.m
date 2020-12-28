clear all
close all

load CLIVE.mat

numberOfSplits = 100;

PLCC = zeros(1,100); SROCC = zeros(1,100); KROCC = zeros(1,100);

numberOfImages = size(AllMOS_release,2);
Features = zeros(numberOfImages, 132); 

path = 'C:\Users\Public\QualityAssessment\ChallengeDB_release\Images';

disp('Feature extraction');
parfor i=1:numberOfImages
    if(mod(i,100)==0)
        disp(i);
    end
    img = imread( strcat(path, filesep, AllImages_release{i}) );
    Features(i,:) = getFeatures(img);
end

disp('Evaluation');
parfor i=1:numberOfSplits
    rng(i);
    if(mod(i,10)==0)
        disp(i);
    end
    p = randperm(numberOfImages);
    
    Data = Features(p,:);
    Target = AllMOS_release(p);
    
    Train = Data(1:round(numberOfImages*0.8),:);
    TrainLabel = Target(1:round(numberOfImages*0.8));
    
    Test  = Data(round(numberOfImages*0.8)+1:end,:);
    TestLabel = Target(round(numberOfImages*0.8)+1:end);
    
    Mdl = fitrgp(Train, TrainLabel', 'KernelFunction', 'rationalquadratic', 'Standardize', true);
    
    Pred = predict(Mdl,Test);
    
    PLCC(i) = corr(Pred,TestLabel');
    SROCC(i)= corr(Pred,TestLabel','Type','Spearman');
    KROCC(i)= corr(Pred,TestLabel','Type','Kendall');
end

disp('----------------------------------');
X = ['Average PLCC after 100 random train-test splits: ', num2str(round(mean(PLCC(:)),3))];
disp(X);
X = ['Average SROCC after 100 random train-test splits: ', num2str(round(mean(SROCC(:)),3))];
disp(X);
X = ['Average KROCC after 100 random train-test splits: ', num2str(round(mean(KROCC(:)),3))];
disp(X);

figure;boxplot([PLCC',SROCC'],{'PLCC','SROCC'});
saveas(gcf,'CLIVE_Box.png');