close all;
clear all;
clc;
for CNR=0:10:20
    clearvars -except CNR
    %%%%% SETUP %%%%%
    % USER PARAMETERS
    % % M: QAM alphabet size
    %   For M = 2 |h|<=pi/2          \
    %   For M = 4 |h|<=pi/4           } Empirical data
    %   Not supported for M ~= [2 4] /
    % % nbits: number of bits for transmission
    % % SNRdB: signal-to-noise ratio (in dB) for noise calculation
    % % rician: channel type, boolean. false: uniform h, true: rician channel
    % % BER: bit-error-rate calculation of not-IM scheme
    % % BER_IM: bit-error-rate calculation of IM scheme
    M = 2;
    nbits = 3*10^4;
    SNRdB = -5:5:10;
%     CNR=20;
    rician = false;
    BER = zeros(size(SNRdB));
    BER_TOTAL_IM = zeros(size(SNRdB));
    % PLL PARAMETERS
    % % TS: symbol period
    % % Fs: symbol rate
    % % BL: noise BW
    % % zeta: natural frequency
    Ts = 0.0001;
    Fs = 1/Ts;
    BL = 10;
    zeta = 1;
    % CHANNEL SETUP
    % In case of a not true value, the channel has a unifrom impulse
    % resonance (ir), whereas a true value implements the rician channel.
    % % h0: manual assignment for h values / default pi/4
    % % ricianchan(TS, FD, K) TS: symbol period, FD: doppler shift, K: rician
    %   K-factor
    % % .StoreHistory: enables plotting the channel's ir
    if ~rician
        h0 = 1; %exp(1i*(pi/4-0.01));
    else
        h = ricianchan(Ts, 1, 1);
        h.StoreHistory = true;
        h0 = h.PathGains;
    end
    
    %%%%% TRANSMITTER %%%%%
    % DATA Prep
    % % input: to-transmit-bitstream
    input = randi([0 1], nbits, 1);
    % M-QAM Modulation
    % % SYMBOLS: bitstream converted to symbolstream depending on modulation
    % % SYMBOLS_IM: symbolstream converted to IM symbolstream (read IM.m file
    %   for exact specifications)
    SYMBOLS = qammod(input, M, 'bin', 'InputType', 'bit');
    SYMBOLS_IM = imod(SYMBOLS);
    % Carrier preparation
    % % CARRIER: carrier signal for SYMBOLS
    % % CARRIER_IM: carrier signal for SYMBOLS_IM
    CARRIER = ones(size(SYMBOLS));
    CARRIER_IM = ones(size(SYMBOLS_IM));
    
    %%%%% CHANNEL %%%%%
    % Based on the channel's type, the symbolstream is filtered through the
    % channel's ir.
    % In case of the rician chan, we first filter IM-symbolstream due to it's
    % bigger size and then we use the stored PathGains to filter the base
    % symbolstream (testing at the exact ir conditions). The carrier signals
    % undergo the same process.
    % % IR_SYMBOLS_IM: IM-symbolstream filtered through ir
    % % IR_CARRIER_IM: IM carrier filtered through ir
    % % IR_SYMBOLS: base symbolstream filtered through ir
    % % IR_CARRIER: base carrier filtered through ir
    if ~rician
        IR_SYMBOLS_IM = sqrt(2) * h0 * SYMBOLS_IM;
        IR_CARRIER_IM = h0 * CARRIER_IM;
        IR_SYMBOLS = h0 * SYMBOLS;
        IR_CARRIER = h0 * CARRIER;
    else
        IR_SYMBOLS_IM = filter(h, SYMBOLS_IM);
        IR_CARRIER_IM = h.PathGains(1:length(CARRIER_IM)) .* CARRIER_IM;
        IR_SYMBOLS = h.PathGains(1:length(SYMBOLS)) .* SYMBOLS;
        IR_CARRIER = h.PathGains(1:length(SYMBOLS)) .* CARRIER;
    end
    
    for n=1:length(SNRdB)
        % Noise Addition
        % Data Noise Addition
        % % noise: the channel's noise
        % % y: the signal received by RX wo-IM
        % % y-IM: the signal received by RX
        noise = comm.AWGNChannel('NoiseMethod', 'Signal to noise ratio (SNR)', 'SNR', SNRdB(n));
        y = noise(IR_SYMBOLS);
        y_IM = noise(IR_SYMBOLS_IM);
        % Carrier Noise Addition
        % % carrier_noise: CNR purposes
        % % carrier: carrier component of the signal received by RX wo-IM
        % % carrier_IM: carrier component of the IM signal received by RX
        carrier_noise = comm.AWGNChannel('NoiseMethod', 'Signal to noise ratio (SNR)', 'SNR', CNR);
        carrier = carrier_noise(IR_CARRIER);
        carrier_IM = carrier_noise(IR_CARRIER_IM);
        %%%%% RECEIVER %%%%%
        % IRC phase approximation
        % % phiMEAN_IM: phase approximation using the received IM signal
        % % phiMEAN: phase approximation using the received base signal
        [phiMEAN_IM, e_IM, c_IM] = PLL_mean(carrier_IM,Ts,BL,zeta,M,1);
        [phiMEAN, e, c] = PLL_mean(carrier,Ts,BL,zeta,M,1);
        % IR Negation
        % % y0: ir-negated base signal
        % % y0_IM: ir-negated IM signal
        y0 = y.*exp(-1i*phiMEAN);
        y0_IM = y_IM.*exp(-1i*phiMEAN_IM);
        % IM Demodulation
        [output_IM,helper,IM_ERROR,QAMDEMOD_ERROR] = idemod4(y0_IM,M,SYMBOLS_IM,input);
        % M-QAM Demodulation
        output = qamdemod(y0,M,'bin','OutputType','bit');
        % Error calculation
        IM_TOTAL_ERROR = IM_ERROR + QAMDEMOD_ERROR;
        BER_TOTAL_IM(n) = IM_TOTAL_ERROR / (length(SYMBOLS_IM) + length(output_IM));
        error = numel(find(output~=input));
        BER(n) = error/length(output); %ber ths kanonikhs periptwshs
    end
    
%     figure('Name','BER', 'NumberTitle', 'off');
%     grid on;
%     semilogy(SNRdB,BER_TOTAL_IM,'-^'); %IM
%     hold on;
%     semilogy(SNRdB,BER,'-+'); %To BER ths kanonikhs periptwshs
%     axis([SNRdB(1) SNRdB(end) 10^-5 10^0]);
%     xlabel(' SNR(dB)');
%     ylabel('BER');
%     legend('IM','w/o-IM');
%     hold off;
%     
%     figure('Name','Throughput', 'NumberTitle', 'off');
%     grid on;
%     plot(SNRdB,(1-BER_TOTAL_IM)*1.5,'-^'); %IM
%     hold on;
%     plot(SNRdB,(1-BER),'-+'); %To Tput ths kanonikhs periptwshs
%     axis([SNRdB(1) SNRdB(end) 0 2]);
%     xlabel(' SNR(dB)');
%     ylabel('Throughput');
%     legend('IM','w/o-IM');
%     hold off;
%     
%     if ~rician
%         figure('Name','PLL phase approx | Rician:off', 'NumberTitle', 'off');
%         hold on;
%         grid on;
%         phoff_real = atan2(imag(h0),real(h0))*ones(size(phiMEAN_IM));
%         plot(phoff_real, 'm');
%         plot(phiMEAN, 'k');
%         plot(phiMEAN_IM, 'c')
%         legend('h', 'w/o-IM', 'Phi_I_M');
%         hold off;
%     else
%         figure('Name','PLL phase approx | Rician: on', 'NumberTitle', 'off');
%         hold on;
%         grid on;
%         plot(angle(h.PathGains), 'm');
%         plot(phiMEAN, 'k');
%         plot(phiMEAN_IM, 'c');
%         legend('h', 'w/o-IM', 'Phi_I_M');
%         hold off;
%     end

    save(['C:\Users\Spiros\Dropbox\szervos\runs\AWGN\AWGN.CNR' num2str(CNR) '.mat'],'IR_CARRIER_IM','phiMEAN_IM','BER','BER_TOTAL_IM')
end
%%%%% PLL functions %%%%%%
function [phiMEAN, e, c] = PLL_mean(eta, Ts, BL, zeta, M, carrier)
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
    e(n) = PLL_phasedetector2(eta(n-1), phiMEAN(n-1), M,carrier);
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

function q = PLL_phasedetector2(eta, phi1, M,carrier)
% ephi0 is already in exponent from call
% e = sin(angle(eta) - angle(ephi0)); original phase error detection
if ~carrier
    diff = angle(eta) - phi1;
    q = sin(-sign(1i^M)*M*diff);
else
    q = angle(eta) - phi1;
end
end

function phiMEAN = PLL_phaseapprox(phiMEAN1, c1)
phiMEAN = phiMEAN1 + c1;
if abs(phiMEAN) > pi
    phiMEAN = phiMEAN - 2 * pi * sign(phiMEAN);
end 
end