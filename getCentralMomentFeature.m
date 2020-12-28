function [feature] = getCentralMomentFeature(imgGray)

    BW = edge(imgGray, 'sobel');
    
    feature(1) = getCentralMoment(0,2,BW);
    feature(2) = getCentralMoment(0,3,BW);
    feature(3) = getCentralMoment(1,1,BW);
    feature(4) = getCentralMoment(2,1,BW);
    feature(5) = getCentralMoment(1,2,BW);
    feature(6) = getCentralMoment(2,0,BW);
    feature(7) = getCentralMoment(2,1,BW);
    feature(8) = getCentralMoment(3,0,BW);

end

