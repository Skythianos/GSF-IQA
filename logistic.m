function y = logistic(b,X)
 
    y = b(1) * (0.5 - 1./(1 + exp(b(2) * (X - b(3)))))+ b(4)*X + b(5);

end