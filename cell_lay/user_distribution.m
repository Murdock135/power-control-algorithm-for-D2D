function [user] = user_distribution(user_no_perbs,bs,cell_rad)
        
k=1;
for i=1:length(bs)
    for j=1:user_no_perbs
    [coord_x,coord_y] = get_coordinates(bs(i,1),bs(i,2), cell_rad);
    user(k,1)=coord_x;
    user(k,2)=coord_y;
    k=k+1;
    end
end