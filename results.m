
%creating cell
number_of_D2D_users = 2;
number_of_cellular_users = 1;
cell_radius = 2000;
[UEd_locations, UEc_locations] = plot_cell(cell_radius, number_of_D2D_users, number_of_cellular_users);


set_of_users = [
    [UEd_locations(1,1), UEd_locations(1,2)], 
    [UEd_locations(2,1), UEd_locations(2,2)],
    [UEc_locations(1,1), UEc_locations(1,2)]
    ];

%Euclidean Distance between the devices
D = pdist(set_of_users);

%calculating channel gain between users
K = 1; %constant
channel_gains = K./D.^4;

target_sir = 5;%target SIR

%sigmoid weighting factors
b = 2;
c = 10;
a = 20;


p_max = 1000*10e-3;%maximum power
noise = 8*10e-17; %background noise
p_initial = ones(1,number_of_cellular_users+number_of_D2D_users).*2.22*10e-16; %initial power for all users

for i=1:length(set_of_users)




