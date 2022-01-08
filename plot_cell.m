function [UEd_locations, UEc_locations] = plot_cell(cell_radius)
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



N = 2; %number of D2D users
M = 1; %number of cellular users
UEd_locations = zeros(N,2);
UEc_locations = zeros(M,2);

%setting the D2D user locations
for i=1:N
    UEd_locations(i,1) = rand(1,1)*radius*cos(2*pi); %setting the x coordinates of UEd
    UEd_locations(1,i) = rand(1,1)*radius*sin(2*pi); %setting the y coordinates of UEd
end
%setting the C-user location
for j=1:M
    UEc_locations(j,1) = rand(1,1)*radius*cos(2*pi); %setting the x coordinates of UEc
    UEc_locations(j,i) = rand(1,1)*radius*sin(2*pi); %setting the y coordinates of UEc
end

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