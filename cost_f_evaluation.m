clc;
clear;
close all;

UEd = 4; % 2 D2D devices (1 pair)
UEc = 1; % 1 cellular devices
%% distances between communication pairs [m]

d_ii = 20; % distance between "intended" or communicating d2d devices i->i
d_ij = 35; % distance between "unintended" or non-communicating d2d devices i->j
d_ko = 50; % distance between cellular and base-station
d_ik = 50; % distance between d2d and cellular 
%% UE link quality

% power vector of all users
pi = 0.02; % power vector of D2D user i [W]
pk = ones(UEc,1)*0.02; % power vector of Cellular user k (fixed) [W]
pj = ones(UEd-2,1)*0.02; % power vector of p(-i) or jth d2d user [w]
n = 0.0001; % noise
% channel gains
gii(1,1) = 1.*(100./d_ii).^2; % link gain from ith d2d to ith d2d device (assuming correlation coef =1)(assuming constant)
gij = 1.*(100./d_ij).^2.*ones(UEd-2,1); % link gain from jth d2d to ith d2d device (assuming correlation coef =1)(assuming constant)
gik = 1.*(100./d_ik).^2; % link gain between d2d and cellular devices


%%  algorithm parameters

pmax = 1000e-3; % 1000 mW
tau = 05; % target SIR is 5 

% sigmoid parameters
b = 2;
c = 10;
%% J vs gii
Ii(1) = 0;
SIR_i(1,1) = 0;
J_i(1) = 0;
J_UEc(1) = 0;

% J vs gii 
i=1;
g_upper = 200;
while gii(1,i)<g_upper
    Ii = pk*gik+pj'*gij+n;
    SIR_i(1,i) = pi*gii(1,i)/Ii;
    J_i(i) = (2*gii(1,i)/Ii).*sigmoid(Ii,gii(1,i))*pi+c.*(tau-SIR_i(1,i))^2;
    gii(1,i+1) = gii(1,i) +1;
    i = i+1;
end
gii = gii(1,1:i-1);
% plot
figure
plot(gii(:),J_i)
xlabel('gii')
ylabel('J')
title('cost vs gii')


%% J vs pi
% resetting values
gii = gii(1);
J_i = 0;
SIR_i = 0;
Ii = 0;

i=1;
pi_initial = pi;
pi_upper =0.15;
while pi_initial(i)<pi_upper
    Ii = pk*gik+pj'*gij+n;
    SIR_i(i) = pi_initial(i)*gii/Ii;
    J_i(i) = (2*gii/Ii).*sigmoid(Ii,gii)*pi_initial(i)+c.*(tau-SIR_i(i))^2;
    pi_initial(i+1) = pi_initial(i) + 0.001;
    i = i+1;
end
pi_initial = pi_initial(1:i-1);
% plot
figure
plot(pi_initial(:),J_i)
xlabel('pi')
ylabel('J')
title('cost vs pi')
hold on
plot(pi_initial(J_i==min(J_i)),min(J_i),'o')

%% Game simulation
clc;
clear; close all;

%% UEc initial transmit power 100 W
d_ii = 200; % distance between "intended" or communicating d2d devices i->i
d_ko = 200; % distance between cellular and base-station
d_ik = 200; % distance between d2d and cellular 
pk = 0.2; % [W]
n = 0.000001; % noise
b = 2;
c = 10;
tau = 2.5;
pmax = 1;
% channel gains
gii = 1.*(100./d_ii).^2; % link gain from ith d2d to ith d2d device (assuming correlation coef =1)(assuming constant)
gik = 1.*(100./d_ik).^2; % link gain between d2d and cellular devices
gko = 1.*(100./d_ko).^2; % uplink gain of UEc

J_i = 0;
J_k = 0;
SIR_i = 0;
SIR_k = 0;
Ii = 0;
Ik = 0;
% getting the optimal strategy of the UEd
i=1;
pi_initial = 0;

while pi_initial(i)<pmax
    pi_initial(i);
    Ii = pk*gik+n;
    SIR_i(i) = pi_initial(i)*gii/Ii;
    current_sig = sigmoid(Ii,gii); % does not change
    J_i(i) = (2*gii/Ii).*current_sig*pi_initial(i)+c.*(tau-SIR_i(i))^2;
    pi_initial(i+1) = pi_initial(i) + 0.001;
    i = i+1;
end
pi = pi_initial(J_i==min(J_i)) % optimal strategy

pi_initial = pi_initial(1:i-1);
% plot
figure
plot(pi_initial(:),J_i)
hold on
plot(pi_initial(J_i==min(J_i)),min(J_i),'o')
hold on

pk_initial = 0;
i=1;
while pk_initial(i)<pmax
    pk_initial(i);
    Ik = pi*gii+n;
    SIR_k(i) = pk_initial(i)*gko/Ik;
    current_sig = sigmoid(Ik,gko);
    J_k(i) = 2*gko/Ik*current_sig*pk_initial(i)+c*(tau-SIR_k(i))^2;
    pk_initial(i+1) = pk_initial(i)+0.001;
    i = i+1;
end
pk = pk_initial(J_k==min(J_k))


pk_initial = pk_initial(1:i-1);
plot(pk_initial(:),J_k,'g')
hold on
plot(pk_initial(J_k==min(J_k)),min(J_k),'o')
hold on
xlabel('pi')
ylabel('J_i')
title('Optimal strategies of UEd and UEc')