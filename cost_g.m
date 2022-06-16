function J = cost_g(g_initial,g_upper)
global UEd UEc d_ii d_ij dcb d_ik pi pk pj n gij gik tau pmax b c 

i=1;
while g_initial(1,i)<g_upper
    I = pk*gik+pj'*gij+n;
    SIR(1,i) = pi*g_initial(1,i)/I;
    J(i) = (2*g_initial(1,i)/I).*sigmoid(I,g_initial(1,i))+c.*(tau-SIR(1,i))^2;
    g_initial(1,i+1) = g_initial(1,i) +1;
    i = i+1;
end
g_initial = g_initial(1,1:i-1);
% plot
figure
plot(g_initial(:),J)
xlabel('gii')
ylabel('J')
title('cost vs gii')