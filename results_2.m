clear all; close all;

%% setting up the system 

%creating cell
number_of_D2D_users = 2;
number_of_cellular_users = 1;
cell_radius = 200;
%[UEd_locations, UEc_locations] = plot_cell(cell_radius, number_of_D2D_users, number_of_cellular_users);
figure(1)
set_of_users = plot_cell_fixed_distance(cell_radius, 30);

% set_of_users = [
%     [UEd_locations(1,1), UEd_locations(1,2)], 
%     [UEd_locations(2,1), UEd_locations(2,2)],
%     [UEc_locations(1,1), UEc_locations(1,2)]
%     ];

%Euclidean Distance between the devices
D = pdist(set_of_users);

%% initializing the algorithm parameters

%calculating channel gain between users
A = 1; %constant
h = A.*((100./D).^4);

tau = 5;%target SIR

%sigmoid weighting factors
b = 2;
c = 10;
a = 1;


p_max = 1000.*1e-3;%maximum power
noise = 8.*10e-15; %background noise
p(1)=2.22.*10e-16; %initial power for all nodes
pg = p.*h; %product_of_channel_gain_and_power for all nodes
y = [];

%% evaluation of the cost function
j_all_nodes = zeros(1,3);
j_for_ith_node = zeros(1,3);
iteration(1) = 1;

%for p=0.00001:0.01:p_max
while p<=p_max
    
    for i=1:length(set_of_users)
        p_all_nodes = ones(1,length(set_of_users)).*p(end); %initial power for all nodes
        pg = p_all_nodes.*h; 
        interference(i) = noise + sum(pg, "all") - pg(i);  %interference for ith user using prev P
        sigmoid_factor(i) = -1 + (2./(1+exp(-(a.*(b/c).*(interference(i)./h(i)))))); %sigmoid_factor for ith user
        sinr(i) = pg(i)./interference(i);
        j_for_ith_node(end, i) = (2.*h(i)./interference(i)).*sigmoid_factor(i)*p_all_nodes(i)+(c.*(tau-sinr(i)).^2); %calculating cost for ith user
        
    end
    j_all_nodes(end+1,:) = j_for_ith_node;
    iteration(end+1) = iteration(end) +1;
    p(end+1) = p(end)+0.0001;
end


figure(2)
plot(iteration,j_all_nodes(:,1))
figure(3)
plot(iteration,j_all_nodes(:,2))
% hold on
% plot(iteration,j_all_nodes(:,3))
% 
% figure(3)
% plot(iteration, p)


    