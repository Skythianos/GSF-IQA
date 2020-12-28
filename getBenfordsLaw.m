function [benford] = getBenfordsLaw()

    for i=1:9
        benford(i)= log10(1+1/i);
    end

end