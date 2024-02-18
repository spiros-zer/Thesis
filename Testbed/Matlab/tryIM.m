close all;
clear all;
clc;

%%%%% SETUP %%%%%
% USER PARAMETERS 
% % M: QAM alphabet size
%   For M = 2 |h|<=pi/2          |
%   For M = 4 |h|<=pi/4          } Empirical data
%   Not supported for M ~= [2 4] |
% % nbits: number of bits for transmission
% % SNRdB: signal-to-noise ratio (in dB) for noise calculation
% % rician: channel type, boolean. false: uniform h, true: rician channel
% % BER: bit-error-rate calculation of not-IM scheme
% % BER_IM: bit-error-rate calculation of IM scheme
M = 4;
nbits = 10000;
SNRdB = 0:20;
rician = true;
BER = zeros(size(SNRdB));
BER_IM = BER;
% PLL PARAMETERS
% % TS: symbol period
% % Fs: symbol rate
% % BL: noise BW
% % zeta: natural frequency
Ts = 0.0001;
Fs = 1/Ts;
BL = 100;
zeta = 1;
% CHANNEL SETUP
% In case of a not true value, the channel has a unifrom impulse
% resonance (ir), whereas a true value implements the rician channel.
% % h0: manual assignment for h values / default pi/4
% % ricianchan(TS, FD, K) TS: symbol period, FD: doppler shift, K: rician
%   K-factor
% % .StoreHistory: enables plotting the channel's ir
if ~rician
    h0 = exp(1i*(pi/4-0.01));
else
    h = ricianchan(Ts, 1, 1);
    h.StoreHistory = true;
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
SYMBOLS_IM = IM('mod', SYMBOLS, M);
SYMBOLS_IM = SYMBOLS_IM - 1-1i;

%%%%% CHANNEL %%%%%
% Based on the channel type the symbolstream is filtered through the
% channel's ir.
% In case of the rician chan, we first filter IM-symbolstream due to it's
% bigger size and then we use the stored PathGains to filter the base
% symbolstream (testing at the exact ir conditions).
% % IR_SYMBOLS_IM: IM-symbolstream filtered through ir
% % IR_SYMBOLS: base symbolstream filtered through ir
if ~rician
    IR_SYMBOLS_IM = h0*SYMBOLS_IM;
    IR_SYMBOLS = h0*SYMBOLS;
else
    IR_SYMBOLS_IM = filter(h, SYMBOLS_IM);
    IR_SYMBOLS = h.PathGains(1:length(SYMBOLS)) .* SYMBOLS;
end

for n=1:length(SNRdB)
    clear input2, clear output_IM
    % Noise Addition
    % The noise added to each signal is different (read the corresponding
    % function for clarifications)
    Esym=sum(abs(SYMBOLS).^2)/length(SYMBOLS); %Calculate actual symbol energy
    % % y_IM: received noisy IM signal
    % % y: received noisy signal
    [y_IM, ~, ~] = add_awgn_noise(IR_SYMBOLS_IM, SNRdB(n), Esym);
    [y, ~, ~] = add_awgn_noise(IR_SYMBOLS, SNRdB(n), Esym);
%     y_IM = IR_SYMBOLS_IM;
%     y = IR_SYMBOLS;
    %%%%% RECEIVER %%%%%
    % IRC phase approximation
    % % phiMEAN_IM: phase approximation using the received IM signal
    % % phiMEAN: phase approximation using the received base signal
    carrier=1;
    [phiMEAN_IM, e_IM, c_IM] = PLL_mean(y_IM, Ts, BL, zeta, M,carrier);
    carrier=0;
    [phiMEAN, e, c] = PLL_mean(y, Ts, BL, zeta, M,carrier);
    % IR Negation
    % % y0: ir-negated base signal
    % % y0_IM: ir-negated IM signal
    y0 = y.*exp(-1i*phiMEAN);
    y0_IM = y_IM.*exp(-1i*phiMEAN_IM);
    % IM Demodulation
    % % y1_IM: demodulated symbolstream. It can now be M-QAM demodulated
    y0_IM = y0_IM + 1+1i;
    y1_IM = IM('demod', y0_IM, M);
    % M-QAM Demodulation
    output_IM = qamdemod(y1_IM, M, 'bin', 'OutputType', 'bit');
    output = qamdemod(y0, M, 'bin', 'OutputType', 'bit');
    % Error calculation
    % For IM we have 3 cases 1) where the RX mistakenly received more
    % symbold than their original number and thus there are more output
    % bits than there should be and 2) the RX disarded the transmited
    % symbols thinking they were noise resutling in less bits than the
    % original number 3) RX got the exact number of symbols that were
    % transmitted.
    if length(output_IM)>length(input) % case 1
        % In case 1 we make an input2 which is the same size as the
        % surplass of bits by assigning -1 as value. This helps at the
        % stage where the input and the output bitstreams are compared.
        input2=input; 
        input2(end+1:length(output_IM)) = -1;
        error_IM = numel(find(input2~=output_IM));
    elseif length(output_IM)<length(input) % case 2
        % In case 2, input2 is shorter than the original input 
        input2 = input(1:length(output_IM));
        error_IM = numel(find(input2~=output_IM)) + length(input(length(output_IM):end));
    else % case 3
        error_IM = er_calc(output_IM, input);
    end
    error = er_calc(output, input);
    BER(n) = (error)/(length(output_IM)+length(output));
    BER_IM(n) = (error_IM)/(length(output_IM)+length(output));
end

figure('Name','BER', 'NumberTitle', 'off');
grid on;
semilogy(SNRdB,BER,'-^');
hold on;
semilogy(SNRdB,BER_IM,'-o');
xlabel(' SNR(dB)');
ylabel('BER');
legend('BER','BER_I_M');
hold off;

if ~rician
%     savefig('awgnchan_BER.fig');
    figure('Name','PLL phase approx | Rician:off', 'NumberTitle', 'off');
    hold on;
    grid on;
    phoff_real = atan2(imag(h0),real(h0))*ones(size(phiMEAN_IM));
    plot(phoff_real, 'm');
    plot(phiMEAN, 'k');
    plot(phiMEAN_IM, 'c')
    legend('h', 'Phi', 'Phi_I_M');
%     savefig('awgnchan_phi.fig');
    hold off;
else
%     savefig('ricianchan_BER.fig');
    figure('Name','PLL phase approx | Rician: on', 'NumberTitle', 'off');
    hold on;
    grid on;
    plot(angle(h.PathGains), 'm');
    plot(phiMEAN, 'k');
    plot(phiMEAN_IM, 'c');
    legend('h', 'Phi', 'Phi_I_M');
%     savefig('ricianchan_phi.fig');
    hold off;
end

%%%%% AWGN noise [1]%%%%%
function [y, Esym, N0] = add_awgn_noise(SYMBOLS, SNRdB, Esym)
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
% Esym=sum(abs(SYMBOLS).^2)/(L); %Calculate actual symbol energy
N0=Esym/SNR; %Find the noise spectral density
noiseSigma=sqrt(N0/2); %Standard deviation for AWGN Noise when x is complex
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
q = sin(-sign(1i^M)*M*diff);
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