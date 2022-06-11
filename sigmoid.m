function sig = sigmoid(I,gii)
    b=2;
    c=10;
    sig = (2./(1+exp(-b./c.*I./gii)))-1; % (2./(1+exp(-b./c.*I./gii)))-1
end
    