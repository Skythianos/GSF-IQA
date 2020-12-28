clear all
close all

load CSIQ.mat

home = pwd;
pathDist = 'C:\Users\Public\QualityAssessment\CSIQ\dst_imgs';
pathRef  = 'C:\Users\Public\QualityAssessment\CSIQ\src_imgs';

cd(pathDist);
if ~exist('ALL', 'dir')
    mkdir 'ALL'
    copyfile awgn/* ALL
    copyfile blur/* ALL
    copyfile contrast/* ALL
    copyfile fnoise/* ALL
    copyfile jpeg/* ALL
    copyfile jpeg2000/* ALL
else
    rmdir('ALL','s')
    mkdir 'ALL'
    copyfile awgn/* ALL
    copyfile blur/* ALL
    copyfile contrast/* ALL
    copyfile fnoise/* ALL
    copyfile jpeg/* ALL
    copyfile jpeg2000/* ALL
end
cd(home)
pathDist = strcat(pathDist, filesep, 'ALL');

dmos = cell2mat(dmos);
numberOfImages = size(dmos,1);

Scores = zeros(numberOfImages, 1);
Features = zeros(numberOfImages, 132);

Filenames=cell(numberOfImages,1);

parfor i=1:numberOfImages
    disp(i);
    if(isnumeric(Image{i}))
        name = int2str(Image{i});
    else
        name = char(Image{i});
    end
    
    type = string(dst_type{i});
    if(strcmp(type,'noise'))
        dst = 'AWGN';
    elseif(strcmp(type,'jpeg'))
        dst = 'JPEG';
    elseif(strcmp(type,'jpeg 2000'))
        dst = 'jpeg2000';
    elseif(strcmp(type,'fnoise'))
        dst = 'fnoise';
    elseif(strcmp(type,'blur'))
        dst = 'BLUR';
    elseif(strcmp(type,'contrast'))
        dst = 'contrast';
    else
        error('Unknown distortion type'); 
    end
    level = int2str(dst_lev{i});
          
    filename = strcat(name, '.', dst, '.', level, '.png');
    
    Filenames{i}=filename;
    
    imgDist = imread(strcat(pathDist, filesep, filename));
    %imgRef  = imread(strcat(pathRef,  filesep, num2str(Image{i}), '.png'));
    
    Features(i,:) = getFeatures(imgDist);
end

Filenames = string(Filenames);

PLCC = zeros(1,100); SROCC = zeros(1,100); KROCC = zeros(1,100);

parfor i=1:100
    disp(i);
    rng(i);
    [Train, Test] = splitTrainTest_CSIQ(Filenames);

    TrainFeatures = Features(Train,:);
    TestFeatures  = Features(Test,:);
    
    YTest = (dmos(Test))';
    YTrain= (dmos(Train))';

    Mdl = fitrensemble(TrainFeatures, YTrain, 'OptimizeHyperparameters','auto');
    %Mdl = fitrtree(TrainFeatures, YTrain, 'OptimizeHyperparameters','auto');
    %Mdl = fitrsvm(TrainFeatures, YTrain, 'KernelFunction', 'linear', 'Standardize', true);
    %Mdl = fitrgp(TrainFeatures, YTrain, 'KernelFunction', 'rationalquadratic', 'Standardize', true);
    %Mdl = fitrsvm(TrainFeatures, YTrain, 'KernelFunction', 'gaussian', 'KernelScale', 'auto', 'Standardize', true);
    Pred= predict(Mdl,TestFeatures);
    
    eval = metric_evaluation(Pred, YTest');
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

%figure;boxplot([PLCC',SROCC',KROCC'],{'PLCC','SROCC','KROCC'});
%saveas(gcf,'CSIQ_Box.png');