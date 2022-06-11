%Author: Qazi Zarif Ul Islam
%email: zayanqm@gmail.com
%Discription: This code is a simulation of L users Distributed Power Control. 
% The difference to CDMA is that intra-cell
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

L = 2;
G = zeros(L,L) % Gii are diagonal elements, Gij are off-diagonal
F = zeros(L,L); 
v = zeros(L,1);
N=0.01*ones(L,1); % Noise power at each receiver 
% specify required SIR levels at each receiver
Tau=[5;5 ;5] %target SIR at each receiver
pmax = 1 %unit mW
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
    v(l) = N(l)*Tau(l)/G(l,l);
end





P=pmax*ones(L,1); % initial transmit Power is set to maximum power
Pt = P;
a=diag(G);D=diag(a); % D is a matrix containing only the intended link gains
SIR=D*P./(F*D*P+N);
global b c
b=2;
c=10;

%% 

