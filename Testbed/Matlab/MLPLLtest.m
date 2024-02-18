%Eidiko thema: Ylopoihsh monteloy prosomoiwshs vroxoy kleidwmenhs fashs se
%pshfiaka systhmata epikoinwnias.
%Ylopoihsh MLPLLtest vivlio PLL, kefalaio 8 sel. 23 (229)
%
%Se ayth thn prospathia ylopoioyme to stoixeio toy PLL poy einai ypeythino
%gia thn ypologismo ths fashs phi, dhladh to phase detector toy PLL.
%Pio sygkekrimena efarmozoyme toys algorithmoys LMS (8.3.2 eksiswsh 8.88)
%kai ton Alternative Stochastic Gradient (8.3.3 eksiswsh 8.87), kathws
%epishs eksetazoume kai thn symperifora ths otan to sin(e[n]) = e[n]
%(mean behavior of phi 8.3.2 eksiswsh 8.82). 

close all;
clear all;
clc;

%Syxnothta ferontos
fc = 100;
%Rythmos deigmatolhpsias / Sampling interval
Ts = 0.001;
%Platos ferontos
a = 1;
%Standard deviation of noise signal
% %Thewroyme pws o thoryvos einai white Gaussian noise kai to shma v logo
% %aytoy einai iso me variance ?^2 = 0.01
sigmav = sqrt(0.01);
%Loop filter
% %Apo th stigmh poy to Loop filter einai iso me stathera tote anaferomaste
% %se PLL prwths takshs. 
KL = 10;
%Dedomena
t = (0:3000) * Ts;
%Timh arxikhs fashs ferontos
% %Ayth thn timh prospathei na proseggizei to phase detector me th gwnia
% %phi. Gia logoys aplothtas exoyme thesei pws oles tis xronikes stigmes h
% arxikh fash einai ish me th monada.
theta = pi/4;
theta = theta*ones(size(t));

phi = MLPLL1(fc, Ts, a, KL, t, theta, sigmav);
phia = MLPLL1a(fc, Ts, a, KL, t, theta, sigmav);
phimean = MLPLLmean(Ts, a, t, theta, KL);

plot(t, phi, t, phia, t, phimean, t, theta);
legend('8.88', '8.89', '8.82', 'theta')

%%%%% (8.79)LMS ALGORITHM %%%%%
function phi = MLPLL1(fc, Ts, a, KL, t, theta, sigmav)
%Shma eisodoy x = feron + thoryvo
x = a * cos(2*pi*fc*t + theta) + sigmav*randn(size(t));
phi = zeros(size(t));
y = phi;
for n=1:length(t)-1
    y(n) = a*cos(2*pi*(n-1)*fc*Ts + phi(n));
    phi(n+1) = phi(n) - 2*(Ts*KL/a)* sin(2*pi*(n-1)*fc*Ts + phi(n))*(x(n)-y(n));
end
end

%%%%% (8.87)ALTERNATIVE STOCHASTIC GRADIENT %%%%%
function phi = MLPLL1a(fc, Ts, a, KL, t, theta, sigmav)
%Shma eisodoy x = feron + thoryvo
x = a * cos(2*pi*fc*t + theta) + sigmav*randn(size(t));
phi = zeros(size(t));
y = phi;
for n=1:length(t)-1
    y(n) = a*cos(2*pi*(n-1)*fc*Ts+phi(n));
    phi(n+1) = phi(n) - 2*(Ts*KL/a)* sin(2*pi*(n-1)*fc*Ts+phi(n))*x(n);
end
end

%%%%% (8.82)MEAN BEHAVIOR %%%%%
function phi = MLPLLmean(Ts, a, t, theta, KL)
phi = zeros(size(t));
for n=1:length(t)-1
    e = theta(n) - phi(n);
    c = KL*e;
    phi(n+1) = phi(n) + Ts*c;
end
end