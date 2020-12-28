function [gx,gy] = gaussian_derivative(imd,sigma) % comput the gaussian derivative
    window1 = fspecial('gaussian',2*ceil(3*sigma)+1+2, sigma);
    winx = window1(2:end-1,2:end-1)-window1(2:end-1,3:end);winx = winx/sum(abs(winx(:)));
    winy=winx';
    gx = filter2(winx,imd,'valid');
    gy = filter2(winy,imd,'valid');
end
