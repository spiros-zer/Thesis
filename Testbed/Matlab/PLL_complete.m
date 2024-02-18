%Gia noise-less transmission comment grammh 47

close all;
clear all;
clc;

% USER PARAMETERS 
M = 4; % QAM alphabet size 
       % For M = 2 |h|<=pi/2         |
       % For M = 4 |h|<=pi/4         } Empirical data
       % Not imported for M ~= [2 4] |
nbits = 10000; %number of bits for transmission
SNRdB = 0:2:20; %signal-to-noise ratio for noise calculation 
rician = true; %channel type false: uniform h, true: rician channel
BER = zeros(size(SNRdB));

% PLL parameters
Ts = 0.0001; %symbol period
Fs = 1/Ts; %symbol rate
BL = 100; %noise BW
zeta = 1; %natural frequency

% Channel parameters
if ~rician
    h0 = exp(1i*(pi/4)); %Manual assignment for h values
else
    h = ricianchan(Ts, 1, 1);
    h.StoreHistory = true;
end

%%%%% TRANSMITTER %%%%%
input = randi([0 1], nbits, 1); %input bitstream generation
% M-QAM Modulation
SYMBOLS = qammod(input, M, 'bin', 'InputType', 'bit');

%%%%% CHANNEL %%%%%
if ~rician
    h = h0 * ones(size(SYMBOLS));
    IR_SYMBOLS = h .* SYMBOLS;
else
    IR_SYMBOLS = filter(h, SYMBOLS);
end

for n=1:length(SNRdB)
    % Noise Addition
    [y, Esym, N0] = add_awgn_noise(IR_SYMBOLS, SNRdB(n));
    %%%%% RECEIVER %%%%%
    % IRC phase approximation
    [phiMEAN, e, c] = PLL_mean(y, Ts, BL, zeta, M);
    y0 = y.*exp(-1i*phiMEAN);
    % Demodulation
    output = qamdemod(y0, M, 'bin', 'OutputType', 'bit');
    % Error calculation
    error = er_calc(output, input);
    BER(n) = error/nbits;
end

if ~rician
    figure('Name','PLL phase approx | Rician:off', 'NumberTitle', 'off');
    hold on;
    grid on;
    phoff_real = atan2(imag(h),real(h));
    plot(1:length(phoff_real), phoff_real, 'm');
%     plot(1:length(e), e, 'b');
%     plot(1:length(c), c, 'g');
    plot(1:length(phiMEAN), phiMEAN, 'k');
%     legend('h', 'Error', 'Control', 'Phi');
    legend('h', 'Phi');
    hold off;
else
    figure('Name','PLL phase approx | Rician: on', 'NumberTitle', 'off');
    hold on;
    grid on;
    plot(angle(h.PathGains), 'm');
%     plot(1:length(e), e, 'b');
%     plot(1:length(c), c, 'g');
    plot(phiMEAN, 'k');
%     legend('h', 'Error', 'Control', 'Phi');

    legend('h', 'Phi');
    hold off;
end
figure('Name','BER', 'NumberTitle', 'off');
grid on;
semilogy(SNRdB,BER,'-o');
xlabel(' SNR(dB)');
ylabel('BER');

%%%%% AWGN noise [1]%%%%%
function [y, Esym, N0] = add_awgn_noise(SYMBOLS, SNRdB)
%Function to add AWGN to a given signal
%Authored by Mathuranathan Viswanathan 
%How to generate AWGN noise in Matlab/Octave by Mathuranathan Viswanathan 
%is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0  International License.
%You must credit the author in your work if you remix, tweak, and build upon the work below
%y=awgn_noise(x,SNR) adds AWGN noise vector to signal 'x' to generate a
%resulting signal vector y of specified SNR in dB
%rng('default');%set the random generator seed to default (for comparison only)
L=length(SYMBOLS);
SNR = 10^(SNRdB/10); %SNR to linear scale
Esym=sum(abs(SYMBOLS).^2)/(L); %Calculate actual symbol energy
N0=Esym/SNR; %Find the noise spectral density
noiseSigma=sqrt(N0/2);%Standard deviation for AWGN Noise when x is complex
n = noiseSigma*(randn(1,L)+1i*randn(1,L));%computed noise  
y = SYMBOLS + transpose(n); %received signal    
end

%%%%% PLL functions %%%%%%
function [phiMEAN, e, c] = PLL_mean(eta, Ts, BL, zeta, M)
% Assembler function for 2nd order PLL combining
% PLL_param: parameter calculation for 2nd order PLL
% PLL_phasedetection: error signal calculation 
% PLL_controlsignal: control signal calculation
% PLL_phaseapprox: calculation of phase approximation phi
phiMEAN = zeros(size(eta));
e = zeros(size(eta));
c = zeros(size(eta));
integrator = 0;
%%%%% 2ND ORDER PLL %%%%%
[Ki, Kp] = PLL_param(Ts, BL, zeta);
for n = 2:length(eta)
    %%%%% PHASE DETECTION %%%%%
    e(n) = PLL_phasedetector2(eta(n-1), phiMEAN(n-1), M);
    %%%%% CONTROL SIGNAL %%%%%
    integrator = integrator + Ki*e(n);
    proportional = Kp*e(n);
    c(n) = proportional+integrator;
    %%%%% PHASE APPROX %%%%%
    phiMEAN(n) = PLL_phaseapprox(phiMEAN(n-1), c(n-1));
end
end

function [Ki, Kp] = PLL_param(Ts, BL, zeta)
%Calculation of 2nd order PLL parameters
wn = 2*BL / (zeta+ 1/(4*zeta)); %natural frequency
Ki = wn^2*Ts^2;
Kp = 2*zeta*wn*Ts;
end

function q = PLL_phasedetector2(eta, phi1, M)
% ephi0 is already in exponent from call
% e = sin(angle(eta) - angle(ephi0)); original phase error detection
diff = angle(eta) - phi1;
q = sin(-M*diff);
end

function phiMEAN = PLL_phaseapprox(phiMEAN1, c1)
phiMEAN = phiMEAN1 + c1;
if abs(phiMEAN) > pi
    phiMEAN = phiMEAN - 2 * pi * sign(phiMEAN);
end 
end

%%%%% Error calculator %%%%%
function error = er_calc(output, input)
% Calculator of the errors between the ouput bitstream and the input 
% bitstream.
error = numel(find(input~=output));
end