function [sKLD] = getSymmetricKullbackLeibler(P,Q)
    if abs(sum(P)-sum(Q)) > 1e-10
        error('P and Q are not probability distributions. They do not sum up to 1.')
    end
    
    sKLD = 0.5*getKullbackLeibler(P,Q) + 0.5*getKullbackLeibler(Q,P);
    
end

