function sig = sigmoid(P,SIR)
    b=2;
    c=10;
    sig = exp(P./SIR.*-b/c+1).^-1*.2-1; %exp(P./SIR(:,end).*-b/c+1).^-1
end
    