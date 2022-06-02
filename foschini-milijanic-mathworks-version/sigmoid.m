function sig = sigmoid(P,SIR)
    b=2;
    c=10;
    sig = (2./(1+exp(-b./c.*P./SIR)))-1; % (2./(1+exp(-b./c.*P./SIR)))-1
end
    