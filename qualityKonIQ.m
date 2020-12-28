clear all
close all

load KonIQ10k.mat    % This mat file contains information about the database (KonIQ-10k)

Directory = 'C:\Users\Public\QualityAssessment\KonIQ-10k\1024x768';  % path to KonIQ-10k database 
numberOfImages = size(mos,1);   % number of images in KonIQ-10k database
numberOfTrainImages = round( 0.8*numberOfImages );   % appx. 80% of images is used for training
numberOfSplits = 100;

Features = zeros(numberOfImages, 132);

parfor i=1:numberOfImages
    if(mod(i,100)==0)
        disp(i);
    end
    img           = imread( strcat(Directory, filesep, names{i}) );
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
    Target = mos(p);
    
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
