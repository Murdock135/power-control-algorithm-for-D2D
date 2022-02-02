clear all; close all;

%% setting up the system 

%creating cell
number_of_D2D_users = 2;
number_of_cellular_users = 1;
cell_radius = 200;
%[UEd_locations, UEc_locations] = plot_cell(cell_radius, number_of_D2D_users, number_of_cellular_users);
set_of_users = plot_cell_fixed_distance(cell_radius, 20);

% set_of_users = [
%     [UEd_locations(1,1), UEd_locations(1,2)], 
%     [UEd_locations(2,1), UEd_locations(2,2)],
%     [UEc_locations(1,1), UEc_locations(1,2)]
%     ];

%Euclidean Distance between the devices
D = pdist(set_of_users);

%% initializing the algorithm parameters

%calculating channel gain between users
K = 1; %constant
h = K./D.^4;

target_sir = 5;%target SIR

%sigmoid weighting factors
b = 2;
c = 10;
a = 20;


p_max = 1000*1e-3;%maximum power
noise = 8*10e-15; %background noise
p_initial = ones(1,length(set_of_users)).*2.22*10e-16; %initial power for all users
p = p_initial;
set_of_power_of_UEs_times_channel_attenuation = p.*h; 
y = [];

%%
for algo_iter=1:100

    for i=1:length(set_of_users)

        interference(i) = noise + sum(set_of_power_of_UEs_times_channel_attenuation, "all") - set_of_power_of_UEs_times_channel_attenuation(i);  %interference for ith user using prev P
        y(i) = (p(i).*h(i))./interference(i); %ith user SIR using prev P
        sigmoid_factor(i) = -1 + (2./(1+exp(-(a.*(b/c).*(interference(i)./h(i)))))); %ith user SIR using prev P
        p(i) = (p(i)./y(i)).*target_sir -  (p(i)./y(i)).*sigmoid_factor(i); %Changing the power of the ith user.
        p(i)=min(p(i),p_max);
        set_of_power_of_UEs_times_channel_attenuation = p.*h;

    end
    
    total_interference = sum(interference, "all");
end
disp(total_interference);





    