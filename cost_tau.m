function J = cost_tau(tau_initial, tau_upper)
global UEd UEc d_ii d_ij dcb d_ik pi pk pj n gii gij gik pmax b c 

i=1;
while tau_initial(1,i)<tau_upper
    I = pk*gik+pj'*gij+n;
    SIR(1,i) = pi*gii(1,i)/I;
    J(i) = (2*gii(1,i)/I).*sigmoid(I,gii(1,i))+c.*(tau_initial(1,i)-SIR(1,i))^2;
    tau_initial(1,i+1) = tau_initial(1,i) +0.001;
    i = i+1;
end
%tau_initial = tau_initial(1,1:i-1);
% plot
figure
plot(t_initial(:),J)
xlabel('tau')
ylabel('J')
title('cost vs tau')