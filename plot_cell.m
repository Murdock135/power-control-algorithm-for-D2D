function plot_cell(cell_radius)
%Input the cell-radius in meters
%Output: Plots the cell layout with cell-centres
%Output

radius = cell_radius;  %radius in meters.

t = linspace(0,2*pi,7);

%center cell
t = linspace(0,2*pi,7);

%center cell
x1 = 0 + radius*cos(t);
y1 = 0 + radius*sin(t);
c_x1 = 0; %BS Location Center Cell x-axis
c_y1 = 0; %BS Location Center Cell y-axis
plot(x1,y1);
hold on
plot(c_x1, c_y1, 'r+')