function [output] = getBilaplacianFeatures(img)
    if(isrgb(img))
        img = rgb2gray(img);
    end

    L1 = [0 1 0;1 -4 1;0 1 0];
    L2 = [1 -2 1;-2 4 -2;1 -2 1];
    L3 = [1 0 1;0 -4 0;1 0 1];
    L4 = [-2 1 -2;1 4 1;-2 1 -2];
    L5 = [-1 -1 -1;-1 8 -1;-1 -1 -1];

    L11 = L1*L1;
    L22 = L2*L2;
    L33 = L3*L3;
    L44 = L4*L4;
    L55 = L5*L5;
    L13 = L1*L3;
    L24 = L2*L4;

    minmax = getMinMax(L11);
    C1 = mat2gray(conv2(img,L11), [minmax(1) minmax(2)]);

    minmax = getMinMax(L22);
    C2 = mat2gray(conv2(img,L22), [minmax(1) minmax(2)]);

    minmax = getMinMax(L33);
    C3 = mat2gray(conv2(img,L33), [minmax(1) minmax(2)]);

    minmax = getMinMax(L44);
    C4 = mat2gray(conv2(img,L44), [minmax(1) minmax(2)]);

    minmax = getMinMax(L55);
    C5 = mat2gray(conv2(img,L55), [minmax(1) minmax(2)]);

    minmax = getMinMax(L13);
    C6 = mat2gray(conv2(img,L13), [minmax(1) minmax(2)]);
    
    minmax = getMinMax(L24);
    C7 = mat2gray(conv2(img,L24), [minmax(1) minmax(2)]);
    
    output(1) = getVarianceInformation(C1, 2); 
    output(2) = getVarianceInformation(C2, 2);
    output(3) = getVarianceInformation(C3, 2);
    output(4) = getVarianceInformation(C4, 2);
    output(5) = getVarianceInformation(C5, 2);
    output(6) = getVarianceInformation(C6, 2);
    output(7) = getVarianceInformation(C7, 2);
    
end

