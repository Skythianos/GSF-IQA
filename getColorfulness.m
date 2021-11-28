function [CF] = getColorfulness(imgRGB)

    imgRGB = im2double(imgRGB);
    
    R = imgRGB(:,:,1);
    G = imgRGB(:,:,2);
    B = imgRGB(:,:,3);
    
    rg = R-G;
    yb = 0.5*(R+G)-B;
    
    CF = sqrt( var(rg(:))*var(rg(:)) + var(yb(:))*var(yb(:)) ) + 0.3*sqrt( mean(rg(:))*mean(rg(:)) + mean(yb(:))*mean(yb(:)) );

end
