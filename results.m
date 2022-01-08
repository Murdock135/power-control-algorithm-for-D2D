%creating cell
[UEd_locations, UEc_locations] = plot_cell(5);

set_of_users = [
    [UEd_locations(1,1), UEd_locations(1,2)], 
    [UEd_locations(2,1), UEd_locations(2,2)],
    [UEc_locations(1,1), UEc_locations(1,2)]
    ];

%Euclidean Distance between the devices
D = pdist(set_of_users);


