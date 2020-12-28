function [regionalFeatures] = getRegionalFeatures(img)
    if(isrgb(img))
        img = rgb2gray(img);
    end
    
    numStrongest = 15;
    
    points            = detectSURFFeatures(img);
    if(size(points,1)<15)
        points = detectSURFFeatures(img, 'MetricThreshold', 1);
    end
    [~, valid_points] = extractFeatures(img, points);
    strongest         = valid_points.selectStrongest(numStrongest);
    [features,~]      = extractFeatures(img, strongest);
    
    Features_1 = reshape(double(features'), [1 numStrongest*64]);
    
    regionalFeatures_1(1) = skewness(Features_1);
    regionalFeatures_1(2) = mean(Features_1);
    regionalFeatures_1(3) = kurtosis(Features_1);
    regionalFeatures_1(4) = getVarianceInformation(Features_1,2);
    regionalFeatures_1(5) = std(Features_1);
    regionalFeatures_1(6) = entropy(Features_1);
    
    points            = detectSURFFeatures(img);
    if(size(points,1)<15)
        points = detectSURFFeatures(img, 'MetricThreshold', 1);
    end
    [~, valid_points] = extractFeatures(img, points, 'FeatureSize', 128);
    strongest         = valid_points.selectStrongest(numStrongest);
    [features,~]      = extractFeatures(img, strongest, 'FeatureSize', 128);
    
    Features_2 = reshape(double(features'), [1 numStrongest*128]);
    
    regionalFeatures_2(1) = skewness(Features_2);
    regionalFeatures_2(2) = mean(Features_2);
    regionalFeatures_2(3) = kurtosis(Features_2);
    regionalFeatures_2(4) = getVarianceInformation(Features_2,2);
    regionalFeatures_2(5) = std(Features_2);
    regionalFeatures_2(6) = entropy(Features_2);
    
    corners            = detectHarrisFeatures(img);
    [~, valid_corners] = extractFeatures(img, corners, 'Method', 'FREAK');
    strongest          = valid_corners.selectStrongest(numStrongest);
    [features,~]       = extractFeatures(img, strongest, 'Method', 'FREAK');
     
    features = double(features.Features);
    
    Features_3 = reshape(double(features'), [1 numStrongest*64]);
    
    regionalFeatures_3(1) = skewness(Features_3);
    regionalFeatures_3(2) = mean(Features_3);
    regionalFeatures_3(3) = kurtosis(Features_3);
    regionalFeatures_3(4) = getVarianceInformation(Features_3,2);
    regionalFeatures_3(5) = std(Features_3);
    regionalFeatures_3(6) = entropy(Features_3);
      
    regionalFeatures = [regionalFeatures_1, regionalFeatures_2, regionalFeatures_3];
end

