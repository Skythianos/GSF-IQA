function [FD] = getFD(img)
    if(size(img,3)==3)
        img = rgb2gray(img);
    end

    [M,N]= size(img);

    FD = zeros(M,N);

    for r=2:7
        rc = @(x) floor(((max(x)-min(x))/r))+ 1; % non-linear filter
        F= colfilt(img, [r r],'sliding', rc);
        B{r}= log(double(F * (49/(r^2))));
    end

    i=log(2:7);
    Nxx=dot(i,i)-(sum(i)^2)/6;

    for m = 1:M
        for n = 1:N
            fd= [B{7}(m,n), B{6}(m,n), B{5}(m,n), B{4}(m,n), B{3}(m,n), B{2}(m,n)]; % Number of boxes multiscale vector
            Nxy=dot(i,fd)-(sum(i)*sum(fd))/6; 
            FD(m, n)= (Nxy/Nxx); % slope of the linear regression line
        end
    end
end