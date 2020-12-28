function [RO, GM, RM] = FGr(im)
    if(isrgb(im))
        im=rgb2gray(im);
    end
    sigma = 0.5;
    [im_Dx,im_Dy] = gaussian_derivative(im,sigma);

    aveKernel = fspecial('average', 3);
    eim_Dx = conv2(im_Dx, aveKernel,'same');
    eim_Dy = conv2(im_Dy, aveKernel,'same');% compute the average directional derivative

    im_D=atan(eim_Dx./(eim_Dy));
    im_D(eim_Dy==0)=pi/2;

    RO=atan(im_Dx./(im_Dy));
    RO(im_Dy==0)=pi/2;

    RO=RO-im_D; % compute RO
    GM=sqrt(im_Dx.^2+im_Dy.^2); % compute GM
    RM=sqrt((im_Dx-eim_Dx).^2+(im_Dy-eim_Dy).^2); %compute RM

end