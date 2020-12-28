function [spread] = getSpread(dist)

    mu = mean(dist);
    spread = 1/numel(dist)*sum(abs(dist-mu));
    
end

