%Lockrange eksereynhsh toy PLL gia 4QAM, gia |h|>pi/4 apotygxanei. Gia
%grafikh parastash prosthhkh toy -pi/4-0.01 & pi/4+0.01 sto dianysma h0
close all;
clear all;
clc;

%%%%% USER PARAMETERS %%%%%
M = 4;
nbits = 20000;
SNRdB = 10;
h0 = [exp(1i*(-pi/4)) exp(1i*(-pi/4+0.1)) exp(1i*(-pi/5)) exp(1i*(-pi/6)) exp(1i*(-pi/18)) exp(1i*(pi/18)) exp(1i*(pi/6)) exp(1i*(pi/5)) exp(1i*(pi/4-0.1)) exp(1i*(pi/4))]; %Manual assignment for h values

% PLL parameters
Ts = 0.01;
BL = 5;
zeta = 1;

%%%%% TRANSMITTER %%%%%
input = randi([0 1], nbits, 1);
% M-QAM Modulation
SYMBOLS1 = qammod(input, M, 'bin', 'InputType', 'bit');
SYMBOLS2 = size(SYMBOLS1);
if M==4
    rot = [cos(pi/4) -sin(pi/4);sin(pi/4) cos(pi/4)];
    s = [1/sqrt(2) 0;0 1/sqrt(2)];
    for i=1:length(SYMBOLS1)
        point = [round(real(SYMBOLS1(i))) round(imag(SYMBOLS1(i)))]';
        point2 = round(s*rot*point);
        SYMBOLS2(i) = complex(point2(1), point2(2));
    end
end
SYMBOLS2 = transpose(SYMBOLS2);

fig1 = figure('Name','PLL lock-range finder: 4QAM', 'NumberTitle', 'off');
for j=1:length(h0)
    %%%%% CHANNEL %%%%%
    [IR_SYMBOLS, h] = irc_applier(SYMBOLS2, h0(j));
    y = IR_SYMBOLS;

    %%%%% RECEIVER %%%%%
    % IRC phase approximation
    [phiMEAN, e, c] = PLL_mean(y, Ts, BL, zeta);
    y0 = y.*exp(-1i*phiMEAN);
    if M==4
        rot = transpose(rot);
        for i=1:length(y0)
            point = [real(y0(i)) imag(y0(i))]';
            point2 = s*rot*point;
            y0(i) = complex(point2(1), point2(2));
        end
    end
    % Demodulation
    output = qamdemod(y0, M, 'bin', 'OutputType', 'bit');
    error = er_calc(output, input);

    phoff_real = atan2(imag(h),real(h));
    subplot(10,1,j);
    plot(1:length(phoff_real), phoff_real, 'm');
    hold on;
    grid on;
    plot(1:length(phiMEAN), phiMEAN, 'k');
    legend('angle(h)', 'Phi');
end


function [IR_SYMBOLS, h] = irc_applier(SYMBOLS, h0)
%Impuse Response Resonance applier for channel chan.
h = h0 * ones(size(SYMBOLS));
IR_SYMBOLS = h .* SYMBOLS;
end

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
y = SYMBOLS + n; %received signal    
end

%PLL functions
function [phiMEAN, e, c] = PLL_mean(eta, Ts, BL, zeta)
phiMEAN = zeros(size(eta));
e = zeros(size(eta));
c = zeros(size(eta));
integrator = 0;
%%%%% 2ND ORDER PLL %%%%%
[Ki, Kp] = PLL_param(Ts, BL, zeta);
for n = 2:length(eta)
    %%%%% PHASE DETECTION %%%%%
    e(n) = PLL_phasedetector2(eta(n-1), phiMEAN(n-1));
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

function q = PLL_phasedetector2(eta, phi1)
% ephi0 is already in exponent from call
diff = angle(eta) - phi1;
q = sin(4*diff);
end

function phiMEAN = PLL_phaseapprox(phiMEAN1, c1)
phiMEAN = phiMEAN1 + c1;
if abs(phiMEAN) > pi
    phiMEAN = phiMEAN - 2 * pi * sign(phiMEAN);
end 
end

%%%%% Error calculator %%%%%
function error = er_calc(output, input)
error = numel(find(input~=output));
end