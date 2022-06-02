%__________________Final Year Project 2021/2022_________________%
% QPSK-OFDM in Rayleigh Channel (noma system)
% By: Nurul Ameera Izzaty Binti Umar
% Matrics Number: 17160366/2 
% _______________________________________________________________%

clearvars; clc; close all; 
%% Parameters of signal
UE = 2;                 % Number of user equipments
M = 4;                  % QPSK: 4 constellations 
K = log2(M);        % Bits/symbol 
N = 655360;       % Number of message bits
n = 64;                 % OFDM subcarriers / IFFT point 
len = 16;              % Length of cyclic prefix 
tot_len = n+len;

Pt = 0:30;             % Variation of transmission power (dB)
pt = (10^-3)*db2pow(Pt);       % Transmission power in linear scale
Pc = 1;                 % BS total dissipated power (W)

BW = 10^6;        % Bandwidth 
No = -174 + 10*log10(BW);   % Noise power (dB)
no = (10^-3)*db2pow(No);    % Noise power in linear scale 
eta = 4;                % Path loss exponent 

%% Distance of users
% User 1 = far user, User 2 = near user
dist1 = 1500;   % 1.5km from BS 
dist2 = 550;     % 0.55km from BS

%% Power allocation coeffcient
a1 = 0.75; a2 = 0.25;

%% Generating random message 
rng(1);
msg1 = randi([0 1],1,N*K);      % UE1 data 
msg2 = randi([0 1],1,N*K);      % UE2 data

%% Split message into symbols and convert to decimal number
par1 = (reshape(msg1,2,[])).';
par2 = (reshape(msg2,2,[])).';

deci1 = bi2de(par1, 'left-msb');
deci2 = bi2de(par2, 'left-msb');

%% Digital Modulation 
qpsk1 = pskmod(deci1,M,pi/M);
qpsk2 = pskmod(deci2,M,pi/M);

%% Superposition coding 
x = (sqrt(a1).*qpsk1) + (sqrt(a2).*qpsk2);

%% Group QPSK output into 64 column to perform 64 point IFFT 
inv_fft = zeros(length(x)/n,n);
mat = (reshape(x,n,[])).';
for u = 1:length(x)/n
    inv_fft(u,:) = ifft(mat(u,:),n);
end

%% Calculation and addition of cyclic prefix
ftcyc = inv_fft(:,n-len+1:n);
cyc = [ftcyc inv_fft];

%% Reshape the size of matrix of transmitted signal
ser_x = reshape(cyc.',1,size(cyc,1)*size(cyc,2));

%% Noise samples 
n1 = sqrt(no)*(randn(1,length(ser_x)) + 1i*randn(1,length(ser_x)))./sqrt(2);
n2 = sqrt(no)*(randn(1,length(ser_x)) + 1i*randn(1,length(ser_x)))./sqrt(2);

%% Rayleigh coefficient 
h1 = sqrt(dist1^-eta)*(randn(1,length(ser_x)) + 1i*randn(1,length(ser_x)))./sqrt(2);
h2 = sqrt(dist2^-eta)*(randn(1,length(ser_x)) + 1i*randn(1,length(ser_x)))./sqrt(2);

g1 = abs(h1).^2;
g2 = abs(h2).^2;

%% Received signal 
p = length(Pt);
BER1 = zeros(1,p);
BER2 = zeros(1,p);
PA1 = zeros(1,p);
PA2 = zeros(1,p);

for u = 1:p
    % Allocated power to each user for particular transmit power
    PA1(u) = pt(u)*a1;
    PA2(u) = pt(u)*a2;
    
    % Received signal 
    y1 = (sqrt(pt(u))*h1.*ser_x) + n1;
    y2 = (sqrt(pt(u))*h2.*ser_x) + n2;
    
    % Equalization 
    eq1 = y1./h1;
    eq2 = y2./h2;
    
    % Reshape the size of received signal to parallel
    par_1 = (reshape(eq1.',tot_len,[])).';
    par_2 = (reshape(eq2.',tot_len,[])).';
    
    % Remove cyclic prefix 
    nocyc1 = par_1(:,len+1:tot_len);
    nocyc2 = par_2(:,len+1:tot_len);
    
    % 64 point FFT
    fft1 = zeros(length(x)/n,n);
    fft2 = zeros(length(x)/n,n);
    for i = 1:length(x)/n
        fft1(i,:) = fft(nocyc1(i,:),n);
        fft2(i,:) = fft(nocyc2(i,:),n);
    end
    
    % Reshape into serial matrix
    lin1 = reshape(fft1.',[],1);
    lin2 = reshape(fft2.',[],1);
    
    % Direct demodulation of UE1
    demod1 = pskdemod(lin1,M,pi/M);
    demap1 = de2bi(demod1, 'left-msb');
    
    % Reshape symbol into message bits
    out_msg1 = reshape(demap1.',1,[]);
    
    %BER of msg1
    BER1(u) = biterr(out_msg1,msg1)/N*K;
    
    % Direct demodulation of UE1 at UE2
    demod12 = pskdemod(lin2,M,pi/M);
    demap12 = de2bi(demod12, 'left-msb');
   
    % Parallel to serial 
    ser_12 = reshape(demap12.',1,[]);
    
    % Remodulate 
    par12 = (reshape(ser_12,2,[])).';
    dec12 = bi2de(par12, 'left-msb');
    mod12 = pskmod(dec12,M,pi/M);
    
    remain = lin2 - sqrt(a1*pt(u)).*mod12;
    demod2 = pskdemod(remain,M,pi/M);
    demap2 = de2bi(demod2, 'left-msb');
    out_msg2 = reshape(demap2.',1,[]);
    
    %BER of msg2
    BER2(u) = biterr(out_msg2,msg2)/N*K;
end

%% SINR Calculation
SINR1_NOMA = zeros(p,length(g1));
SINR2_NOMA = zeros(p,length(g2));
SINR1_OMA = zeros(p,length(g1));
SINR2_OMA = zeros(p,length(g2));

% Signal-to-Interference-and-Noise-Ratio (SINR) of NOMA & OMA
for i = 1:p
    SINR1_NOMA(i,:) = (PA1(i).*g1)./(g1.*PA2(i) + n1);
    SINR2_NOMA(i,:) = (PA2(i).*g2)./n2;
    SINR1_OMA(i,:) = (pt(i).*g1)./n1;
    SINR2_OMA(i,:) = (pt(i).*g2)./n2;
end

%% Data Rate calculation
R1_NOMA = zeros(p,length(g1));
R2_NOMA = zeros(p,length(g2));
R1_OMA = zeros(p,length(g1));
R2_OMA = zeros(p,length(g2));

for i = 1:p
    R1_NOMA(i,:) = log2(1 + SINR1_NOMA(i,:));
    R2_NOMA(i,:) = log2(1 + SINR2_NOMA(i,:));
    R1_OMA(i,:) = (1/UE)*(log2(1 + SINR1_OMA(i,:)));
    R2_OMA(i,:) = (1/UE)*(log2(1 + SINR2_OMA(i,:)));
end

%% Plotting of graph 
%  BER vs transmitted power
figure(1);
semilogy(Pt, BER1, '-.r', 'linewidth', 1.0);
hold on; grid on;
semilogy(Pt, BER2, '-sb', 'linewidth', 1.0);
title('Bit Error Rate of users');
xlabel('Transmit power (dB)');
ylabel('BER');
legend('UE1 = Far user', 'UE2 = Near user');

% Allocated power to users vs transmit power
% figure(2);
% pa1 = pow2db(PA1)./(10^3);
% pa2 = pow2db(PA2)./(10^3);
% plot(Pt, pa1, '-.r', 'linewidth', 1.0);
% hold on; grid on;
% plot(Pt, pa2, '-*b', 'linewidth', 1.0);
% title('Allocated power to users');
% xlabel('Transmit power (dB)');
% ylabel('Allocated power (dB)');
% legend('UE1 = Far user', 'UE2 = Near user');

% % Plotting SINR of users
figure(3);
semilogy(Pt, mean(abs(SINR1_NOMA.')), '--dk', 'linewidth', 1.0);
hold on; grid on;
semilogy(Pt, mean(abs(SINR2_NOMA.')), '--dr', 'linewidth', 1.0);
semilogy(Pt, mean(abs(SINR1_OMA.')), '--*b', 'linewidth', 1.0);
semilogy(Pt, mean(abs(SINR2_OMA.')), '--*g', 'linewidth', 1.0);
title('SINR of users in NOMA & OMA system given transmit power');
xlabel('Transmit power (dB)');
ylabel('SINR');
legend('NOMA SINR UE1', 'NOMA SINR UE2', 'OMA SINR UE1', 'OMA SINR UE2');

% Plotting data rate vs transmit power for NOMA and OMA
figure(4);
semilogy(Pt, mean(abs(R1_NOMA.')), '--k', 'linewidth', 1.0);
hold on; grid on;
semilogy(Pt, mean(abs(R2_NOMA.')), '-sb', 'linewidth', 1.0);
semilogy(Pt, mean(abs(R1_OMA.')), '-dg', 'linewidth', 1.0);
semilogy(Pt, mean(abs(R2_OMA.')), '-*r', 'linewidth', 1.0);
title('Achievable data rate of users');
xlabel('Transmit power(dBm)');
ylabel('Achievable capacity (bits/Hz)');
legend('NOMA rate UE1', 'NOMA rate UE2', 'OMA rate UE1', 'OMA rate UE2');


