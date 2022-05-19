clc;
clear;

UEd = 4; % 2 pairs of D2D devices
UEc = 5; % 5 cellular devices

dd = 10; % distance between d2d devices [m]
dcb = 50; % distance between cellular and base-station [m]
ddc = 20; % distance between d2d and cellular devices [m]

% initial time
t = 1;
% power vector of all users
pi = ones(UEd,t)*2.22e-16; % power vector of D2D users [W]
pk = ones(UEc,t)*2.22e-16; % power vector of Cellular users (fixed) [W]

% algorithm parameters
pmax = 1000e-3 % 1000 mW
tau = db2pow(5); % target SIR is 5 dB
gii = ones(UEd,t)*100/dd; % link gain from d2d to d2d device (assuming correlation coef =1)(assuming constant_
gik = ones(UEd+UEc,t)*100/dc; % link gain between d2d and cellular devices
%% algorithm

% starting from t = 2
t = 2;

while pi<pmax
    for device=1:UEd 
        y = pi(device,t-1)*
        pi(device,t) = tau.*(pi(device,t-1)/y)
    end
    t = t+1
end
disp(pi)
