function [UEd_locations, UEc_locations] = plot_cell(cell_radius, UEds, UEcs)
%Input the cell-radius in meters
%Output: Plots the cell layout with cell-centres
%Output

radius = cell_radius;  %radius in meters.

%this is required for the heptagon
t = linspace(0,2*pi,7);

x1 = 0 + radius*cos(t);
y1 = 0 + radius*sin(t);

%marking the base station and the user locations in the cell
c_x1 = 0; %BS Location Center Cell x-axis
c_y1 = 0; %BS Location Center Cell y-axis



N = UEds; %number of D2D users
M = UEcs; %number of cellular users
UEd_locations = rand(N,2)*radius;
UEc_locations = rand(M,2)*radius;


%plotting the cell
plot(x1,y1);
hold on
%plotting the bs
plot(c_x1, c_y1, 'r+')
hold on
%plotting the UEd's
plot(UEd_locations(1,1),UEd_locations(1,2), 'bo')
hold on
plot(UEd_locations(2,1),UEd_locations(2,2),'bo')
hold on
%plotting the UEc
plot(UEc_locations(1,1),UEc_locations(1,2),'go')