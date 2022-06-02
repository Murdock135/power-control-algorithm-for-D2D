clc;
clear;

UEd = 2; % 2 D2D devices (1 pair)
UEc = 1; % 1 cellular devices
%% distances between communication pairs [m]

dd = 20; % distance between d2d devices
dcb = 50; % distance between cellular and base-station
ddc = 20; % distance between d2d and cellular 
%% UE link quality

% power vector of all users
pi = ones(UEd,1)*2.22e-16; % power vector of D2D users [W]
pk = ones(UEc,1)*2.22e-16; % power vector of Cellular users (fixed) [W]

% channel gains
gii = 1.*(100./dd).^2; % link gain from d2d to d2d device (assuming correlation coef =1)(assuming constant)
gik = 1.*(100./ddc).^2; % link gain between d2d and cellular devices
%%  algorithm parameters

pmax = 1000e-3; % 1000 mW
tau = 5; % target SIR is 5 

Id = zeros(UEd,1); % initialize interference to d2d devices
yd = ones(UEd,1); % initialize SINR for d2d devices
yc = ones(UEc,1); % initialize SINR for cellular devices
sigmoid = ones(UEd,1); % initialize sigmoid factor for d2d devices

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
%while pi<pmax
while t<100000
    if pi(:)>=pmax
        disp('pi is bigger than pmax')
    end
    for device=1:UEd 
        Id(device,t) = sum(pi,'all')*gii-pi(device,t).*gii+pk.*gik;
        yd(device,t) = 128*(pi(device,t)*gii)/Id(device,t) ;
        sigmoid(device,t) = 2/(1+exp((-b/c)*(pi(device,t)/yd(device,t))))-1;
        pi_calc = tau.*(pi(device,t)/yd(device,t))-sigmoid(device,t)*(pi(device,t)/yd(device,t));
        pi(device,t+1) = pi_calc;
%         if pi_calc<pi(device,t)&&(pi_calc>0)
%             pi(device,t+1) = pi_calc
%         else
%             pi(device,t+1) = pi(device,t)
%         end
    end
    t = t+1;
end

% omitting the power values at the t(end), because they're greater than
% pmax
pi = pi(:,1:end-1);

% displaying the final time
t-1; % Final time is t=t-1 because at t=t, the pi's are actually greater than pmax.

% calculate system parameters after the powers have converged
% for device=1:UEd
%     Id(device,t) =  sum(pi,'all')*gii-pi(device,t-1).*gii+pk.*gik;
%     yd(device,t) = 128*(pi(device,t-1)*gii)/Id(device,t) ;
%     sigmoid(device,t) = 2/(1+exp((-b/c)*(pi(device,t-1)/yd(device,t))))-1;
% end

%% evaluation of cost function
J1 = 2.*gii./Id(1,:).*sigmoid(1,:).*pi(1,:)+c.*(tau-yd(1,:)).^2;
%% plots

figure(1)
plot(1:t-1,pi(1,:))
ylabel('power')
figure(2)
plot(1:t-1,yd(1,:))
ylabel('Interference to UEd1')
figure(3)
plot(1:t-1,J1)
figure(4)
plot(1:t-1,sigmoid(1,:))
ylabel('sigmoid')
figure(5)
plot(1:t-1,yd(1,:))
ylabel('SIR_UEd1')