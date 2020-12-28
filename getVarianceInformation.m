function V= getVarianceInformation(im, type)
    % compute the statistics variance of RO, RM and GM
    %   Detailed explanation goes here
    % im=double(im);
    mintemp=min(im(:))-1;
    maxtemp=max(im(:))+1;

    if type==1
        x=round(mintemp):0.3:round(maxtemp); %quantization for RO
    elseif type==2
        x=round(mintemp):round(maxtemp); %quantization for GM or RM
    end
    his=hist(im(:),x); 
    his=his/sum(his(:)); %do statistics analysis

    V=std(his(:)); %compute the variance of statistics
end