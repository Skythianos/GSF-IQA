function KLD = getKullbackLeibler(P,Q)
    if abs(sum(P)-sum(Q)) > 1e-10
        error('P and Q are not probability distributions. They do not sum up to 1.')
    end
    MP = numel(P);   % no. of bins of P
    MQ = numel(Q);   % no. of bins of Q
    if MP ~= MQ
        error('WARNING: P and Q have different size!')
    end
    M   = numel(P);                   
    P   = reshape(P,[M,1]);           
    Q   = reshape(Q,[M,1]);
    KLD = nansum( P .* log2( P./Q ) );
end