SNRdB = -5:5:10;
data = cell(5,1);
for k = 1:3
    data{k} = load(['AWGN.CNR' num2str(10*(k-1)) '.mat']);
end
% BER %
figure('Name','BER', 'NumberTitle', 'off');
semilogy(SNRdB,data{1}.BER_TOTAL_IM,'-^');
hold on;
grid on;
for k=2:3
    semilogy(SNRdB,data{k}.BER_TOTAL_IM,'-^');
end
for k=1:3
    semilogy(SNRdB,data{k}.BER,'-+');
end
axis([SNRdB(1) SNRdB(end) 10^-5 10^0]);
xlabel(' SNR(dB)');
ylabel('BER');
legend('IM CNR=0dB','IM CNR=10dB','IM CNR=20dB','NoIM CNR=0dB','NoIM CNR=10dB','NoIM CNR=20dB');
hold off;

% TPUT %
figure('Name','Throughput', 'NumberTitle', 'off');
plot(SNRdB,(1-data{1}.BER_TOTAL_IM)*1.5,'-^');
hold on;
grid on;
for k=2:3
    semilogy(SNRdB,(1-data{k}.BER_TOTAL_IM)*1.5,'-^');
end
for k=1:3
    semilogy(SNRdB,(1-data{k}.BER),'-+');
end
plot(SNRdB,(1-data{1}.BER),'-+');
axis([SNRdB(1) SNRdB(end) 0 2]);
xlabel(' SNR(dB)');
ylabel('Throughput');
legend('IM CNR=0dB','IM CNR=10dB','IM CNR=20dB','NoIM CNR=0dB','NoIM CNR=10dB','NoIM CNR=20dB');
hold off;

% theta approx %
figure('Name','PLL phase approx', 'NumberTitle', 'off');
hold on;
grid on;
plot(angle(data{1}.IR_CARRIER_IM), 'k');
plot(data{1}.phiMEAN_IM)
xlabel('samples');
ylabel('Phase (rad)');
for k=2:3
    plot(data{k}.phiMEAN_IM)
end
legend('IR phase','CNR_{approx}=0dB','CNR_{approx}=10dB','CNR_{approx}=20dB');
hold off;