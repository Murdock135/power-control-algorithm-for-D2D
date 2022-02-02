function  [set_of_UEs, UE_distances]=plot_cell_fixed_distance(cell_radius, distance_UEd_UEd)
%Input the cell-radius in meters, and the distance between UEds. The
%location of the UEc is fixed at (20,20)
%Output: Plots the cell and store the locations of all UEs

radius = cell_radius;  %radius in meters.

%this is required for the heptagon
t = linspace(0,2*pi,7);

x1 = 0 + radius.*cos(t);
y1 = 0 + radius.*sin(t);

%marking the base station and the user locations in the cell
c_x1 = 0; %BS Location Center Cell x-axis
c_y1 = 0; %BS Location Center Cell y-axis



%N = N; %number of D2D users
%M = M; %number of cellular users

d_UEd = distance_UEd_UEd;

%Fixing the locations of the UEs
UEd_1_Location = [-50 -50];
UEd_2_Location = [-50 -50+d_UEd];
UEc_location = [20 20];

set_of_UEs = [[UEd_1_Location]; [UEd_2_Location]; [UEc_location]];
UE_distances = pdist(set_of_UEs);

x_coordinates = [UEd_1_Location(1), UEd_2_Location(1), UEc_location(1)];
y_coordinates = [UEd_1_Location(2), UEd_2_Location(2), UEc_location(2)];


%plotting the cell
plot(x1,y1);
hold on
%plotting the bs
plot(c_x1, c_y1, 'r+')
hold on
%plotting the users
plot(x_coordinates, y_coordinates, 'bo')
