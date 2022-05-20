clc;
clear;

UEd = 4; % 2 pairs of D2D devices
UEc = 5; % 5 cellular devices
d2d_pairs = nchoosek(UEd,2); % combinations of d2d pairs 4C2=6
dc_pairs = nchoosek(UEc+UEd,2); % combinations of d2d-cellular pairs 9C2=36

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
gii = ones(d2d_pairs,t)*(100/dd).^2; % link gain from d2d to d2d device (assuming correlation coef =1)(assuming constant_
gik = ones(dc_pairs,t)*(100/ddc).^2; % link gain between d2d and cellular devices
I = ones(UEd,t) % initialize interference to d2d devices
yd = ones(UEd,t) % initialize SINR for d2d devices
yc = ones(UEc,t) % initialize SINR for cellular devices
sigmoid = ones(UEd,t) % initialize sigmoid factor for d2d devices
b = 2;
c = 10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% d2d-pair the channel links visualized (d2d-cellular pairs will follow
% similar link matrix

% gii = | 0.5 1->2
%       | 0.3 2->3
%       | 0.2 3->4
%       | 0.6 1->3
%       | 0.9 4->2
%% algorithm

while pi<pmax
    for device=1:UEd
        I(device,t) = pi(:,t)'*gii(:,t)-pi(device,t)*gii(device,t)+pk(:,t)'*gik(:,t)
        yd(device,t) = (pi(device,t)*gii(device,t))/I(device,t) % assume that device x wants to establish communication with device x+1
        sigmoid(device,t) = 2/(1+exp((-b/c)*(pi(device,t)/yd(device,t))))
        pi_calc = tau.*(pi(device,t)/yd(device,t))-sigmoid(device,t);
        if pi_calc<pi(device,t)&&(pi_calc>0)
            pi(device,t+1) = pi_calc
        end
    end
    t = t+1
end

