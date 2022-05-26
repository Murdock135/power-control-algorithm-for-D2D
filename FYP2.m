clc;
clear;

UEd = 4; % 2 pairs of D2D devices
UEc = 5; % 5 cellular devices
d2d_pairs = nchoosek(UEd,2); % combinations of d2d pairs 4C2=6
dc_pairs = nchoosek(UEc+UEd,2)-nchoosek(UEc,2); % combinations of d2d-cellular pairs 9C2-5C2=26

dd = 15; % distance between d2d devices [m]
dcb = 50; % distance between cellular and base-station [m]
ddc = 20; % distance between d2d and cellular devices [m]


% power vector of all users
pi = ones(UEd,1)*2.22e-16; % power vector of D2D users [W]
pk = ones(UEc,1)*2.22e-16; % power vector of Cellular users (fixed) [W]

% algorithm parameters
pmax = 1000e-3 % 1000 mW
tau = 5; % target SIR is 5 
gii = ones(d2d_pairs,1)*(100/dd).^2; % link gain from d2d to d2d device (assuming correlation coef =1)(assuming constant)
gik = ones(dc_pairs,1)*(100/ddc).^2; % link gain between d2d and cellular devices
I = ones(UEd,1) % initialize interference to d2d devices
yd = ones(UEd,1) % initialize SINR for d2d devices
yc = ones(UEc,1) % initialize SINR for cellular devices
sigmoid = ones(UEd,1) % initialize sigmoid factor for d2d devices

% sigmoid parameters
b = 2;
c = 10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% d2d-pair channel links visualized (d2d-cellular pairs will follow
% similar link matrix

% gii = | 0.5 1->2
%       | 0.3 2->3
%       | 0.2 3->4
%       | 0.1 4->1
%       | 0.6 1->3
%       | 0.9 4->2
%
% Therefore, one D2D device (device is the counter name in the loop in the next section) will be affected by 3 links
% Note: In the algorithm, we consider the links to be equally strong
%% algorithm

% initial time
t = 1;
while pi<pmax
    if pi>=pmax
        disp('pi is bigger than pmax')
    end
    for device=1:UEd 
        I(device,t) = pi(:,t)'*gii(1:UEd,1)-pi(device,t)*gii(1,1)+pk(:,1)'*gik(1:UEc,1);
        yd(device,t) = (pi(device,t)*gii(1,1))/I(device,t) 
        sigmoid(device,t) = 2/(1+exp((-b/c)*(pi(device,t)/yd(device,t))))-1;
        pi_calc = tau.*(pi(device,t)/yd(device,t))-sigmoid(device,t)*(pi(device,t)/yd(device,t));
        pi(device,t+1) = pi_calc;
%         if pi_calc<pi(device,t)&&(pi_calc>0)
%             pi(device,t+1) = pi_calc
%         else
%             pi(device,t+1) = pi(device,t)
%         end
    end
    t = t+1
end

% omitting the power values at the t(end)
pi = pi(:,1:end-1)

% displaying the final time
t-1 % Final time is t=t-1 because at t=t, the pi's are actually greater than pmax.

% calculate system parameters after the powers have converged
for device=1:UEd
    I(device,t) = pi(:,t-1)'*gii(1:UEd,1)-pi(device,t-1)*gii(1,1)+pk(:,1)'*gik(1:UEc,1);
    yd(device,t) = (pi(device,t-1)*gii(1,1))/I(device,t) 
end
