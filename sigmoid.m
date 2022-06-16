function sig = sigmoid(Interference,channel_gain)
    b=2;
    c=10;
    sig = (2./(1+exp(-b./c.*Interference./channel_gain)))-1; % (2./(1+exp(-b./c.*I./gii)))-1
end
    