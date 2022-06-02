%Author: li.lu
%email: lte_a@qq.com
%Discription: This code is a simulation of L users Distributed Power Control
%algorithm used in OFDM networks. The difference to CDMA is that intra-cell
%interference. This code uses the sources of Alex Dytso(email:
%odytso2@uic.edu) and the words from book "Power Control in Wireless
%Cellular Networks"(by Mung Chiang). Thanks to both authors. 

%Discription: This code is a simulation of K user Distributed Power Control
%Algorithm:  Distributive Power control

%%
clc, clear all, clf


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% System parameter initialization
% L: number of users.
% G: channel gain of amplitude. 
% delta: belonging 
% F: nonnegative matrix. F_{lj} = G_{lj} if l ~= j, and F_{lj} = 0 if l = j
% v: nonnegative vector. v_l = 1/G_{ll}
% pmax: upper bound of the total power constraints.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

L = 3;
G = zeros(L,L);
F = zeros(L,L);
v = zeros(L,1);
N=0.01*ones(L,1); % Noise power at each receiver 
% specify required SIR levels at each receiver
Gamm=[0.1;0.2 ; 0.3]; %target SIR at each receiver
pmax = 0.5; %unit mW
%%

%init G
for l = 1:1:L
    for j = 1:1:L
        if l~= j
            G(l,j) = rand(1,1);
        else
            G(l,j) = rand(1,1);
        end
    end
end
%%

%init F v
for l = 1:1:L
    for j = 1:1:L
        if l ~= j
            F(l,j) = G(l,j)/G(l,l);
        else
            F(l,j) = 0;
        end
    end
    v(l) = N(l)*Gamm(l)/G(l,l);
end





P=pmax*ones(L,1); % initial transmit Power
a=diag(G);D=diag(a);
SIR=D*P./(F*D*P+N);



%algorithm starts here
iterations=1;
Err=ones(L,1); %some initial error value  
while max(Err)>0.000001  % I choose maximum erro to be a divergence criteria
     
    P=(Gamm./SIR(:,iterations)).*P; % New power used by transmitters
    iterations=iterations+1;
    SIR(:,iterations)=D*P./(F*D*P+N);% new SIR
    
    Err(:,iterations)=abs(Gamm- SIR(:,iterations)); %error
   
    
    
end
    
%ploting 

x=1:iterations
figure(1)
plot(x,SIR(1,:),'-.',x,SIR(2,:),'-.g',x,SIR(3,:),'-.r')
 xlabel('Iterations')
 ylabel('SIR')
 title('SIR vs number of Iterations');
     legend(' SIR of user 1',' SIR of user 2',' SIR of user 3');

figure(2)
plot(x,Err(1,:),'-.',x,Err(2,:),'-.g',x,Err(3,:),'-.r')
 ylabel('Err')


