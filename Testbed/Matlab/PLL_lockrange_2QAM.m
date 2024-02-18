%Lockrange eksereynhsh toy PLL gia 2PSK, gia |h|>pi/2 apotygxanei. Gia
%grafikh parastash prosthhkh toy -pi/2-0.01 & pi/2+0.01 sto dianysma h0
close all;
clear all;
clc;

%%%%% USER PARAMETERS %%%%%
M = 2;
nbits = 20000;
SNRdB = 10;
h0 = [exp(1i*(-pi/2)) exp(1i*(-pi/2+0.1)) exp(1i*(-pi/3)) exp(1i*(-pi/4)) exp(1i*(-pi/6)) exp(1i*(pi/6)) exp(1i*(pi/4)) exp(1i*(pi/3)) exp(1i*(pi/2-0.1)) exp(1i*(pi/2))]; %Manual assignment for h values

% PLL parameters
Ts = 0.01;
BL = 5;
zeta = 1;

%%%%% TRANSMITTER %%%%%
input = randi([0 1], nbits, 1);
% M-QAM Modulation
SYMBOLS1 = qammod(input, M, 'bin', 'InputType', 'bit');

fig1 = figure('Name','PLL lock-range finder: 2QAM', 'NumberTitle', 'off');
for j=1:length(h0)
    %%%%% CHANNEL %%%%%
    [IR_SYMBOLS, h] = irc_applier(SYMBOLS1, h0(j));
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
q = sin(2*diff);
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