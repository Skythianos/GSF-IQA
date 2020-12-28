function [globalFeatures] = getGlobalFeatures(imgRGB)
    FD = getFD(imgRGB);
            
    imgRGB = im2double(imgRGB);
    imgGray = rgb2gray(imgRGB);
    YCbCr = rgb2ycbcr(imgRGB);
    
    Y = YCbCr(:,:,1); 
    Y = mat2gray(Y, [16/255, 235/255]);
    Cb= YCbCr(:,:,2);
    Cb= mat2gray(Cb,[16/255, 240/255]);
    Cr= YCbCr(:,:,3);
    Cr= mat2gray(Cr,[16/255, 240/255]);
    
    [FD_Dist,~] = histcounts(FD(:), [-2 -1.5 -1 -0.5 0 0.5 1 1.5 2 2.5 3], 'Normalization', 'probability');

    [~,cH,cV,cD] = dwt2(imgRGB,'sym4','mode','per');
    [DCT]        = dct2(imgGray);
    [~,S,~]      = svd(imgGray);
    
    FDD_cH = getExtendedFDD(cH);
    FDD_cV = getExtendedFDD(cV);
    FDD_cD = getExtendedFDD(cD);
    FDD_DCT= getExtendedFDD(DCT);
    FDD_S  = getExtendedFDD(S);
    
    [ro,gm,rm]=FGr(imgRGB);
    
    globalFeatures = [...
        FD_Dist,...
        skewness(FD_Dist), kurtosis(FD_Dist), ...
        entropy(FD_Dist), median(FD_Dist), getSpread(FD_Dist), std(FD_Dist),...
        FDD_cH, FDD_cV, FDD_cD, FDD_DCT, FDD_S, ...
        getBilaplacianFeatures(Y), ...
        getBilaplacianFeatures(Cb), ...
        getBilaplacianFeatures(Cr), ...
        getCentralMomentFeature(imgGray), ...
        getVarianceInformation(ro,1), getVarianceInformation(rm,2), getVarianceInformation(gm,2), ...
        getColorfulness(imgRGB), ...
        getMLVSharpnessMeasure(imgGray), getDarkChannelFeature(imgRGB), ...
        getGlobalContrastFactor(imgRGB)];
end

