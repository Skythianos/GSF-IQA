function [fD] = getFirstDigit(x)

    if(x==0)
        fD=0;
    else
    
        if(x<0)
            x=x*(-1);
        end
    
        if(x<1)
            while(x<1)
                x=x*10;
            end
        end
    
        while(x>=10)
            x=x/10;
        end
       
        fD = floor(x);
    end
end

