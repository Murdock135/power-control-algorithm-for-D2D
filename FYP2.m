clc;
clear;

UEd = 4; % 2 pairs of D2D devices
UEc = 5; % 5 cellular devices

dd = 10; % distance between d2d devices [m]
dcb = 50; % distance between cellular and base-station [m]

% power vector of all users
pi = ones(UEd,1)*2.22e-16; % power vector of D2D users [W]
pk = ones(UEc,1)*2.22e-16; % power vector of Cellular users (fixed) [W]

