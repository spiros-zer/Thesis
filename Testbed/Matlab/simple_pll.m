close all;
clear all;
reg1=0; %phi(n-1)
reg2=0; %e(n-1)
reg3=0; %c(n-1)
eta=0.707;
theta=2*pi/100;
kp=((4*eta*theta)/(1+2*eta*theta+theta^2));
ki=((4*theta^2)/(1+2*eta*theta+theta^2));
d_phi_1=1/20;
n_data=100;
for nn=1:n_data
    phi1_reg(nn)=reg1+d_phi_1; %original phase
    %phase detection
    s1_reg(nn)=exp(1i*2*pi*reg1);
    s2_reg(nn)=exp(1i*2*pi*reg2);
    t=s1_reg(nn)*conj(s2_reg(nn));
    phi_error_reg(nn)=atan(imag(t)/real(t))/(2*pi); %e(n)
    %control signal
    sum1=kp*phi_error_reg(nn)+phi_error_reg(nn)*ki+reg3; %c(n)
    reg1_reg(nn)=reg1;
    reg2_reg(nn)=reg2;
    reg1=phi1_reg(nn);
    reg2=reg2+sum1;
    reg3=reg3+phi_error_reg(nn)*ki;
    %phase approx
    phi2_reg(nn)=reg2; %phi(n)
end
figure(1)
plot(phi1_reg);
hold on;
plot(phi2_reg,'r');
hold off;
grid on;
title('Phase Plot');
xlabel('Samples');
ylabel('Phase');