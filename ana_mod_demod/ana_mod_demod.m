clc;
close all;
clear all;

A0 = 1;
Ka = 1.5;
Fs = 300;

% Modulating signal
Am = 1;
fa = 10;
Ts = 1/Fs;
t = 0:Ts:1-Ts;
ym = Am*sin(2*pi*fa*t);
figure(1);
subplot(5,2,1);
plot(t,ym);
title('Modulating signal');

[YfreqDomain,frequencyRange] = centeredFFT(ym,Fs);
subplot(5,2,2)
stem(frequencyRange,abs(YfreqDomain));
title('Frequency of modulated signal');
axis([-(fa+5) (fa+5) 0 1]);

%Carrier signal
Ac = 1;
fc = fa*10;
Tc = 1/fc;
yc = Ac*sin(2*pi*fc*t);
subplot(5,2,3);
plot(t,yc);
title('Carrier signal');

[YfreqDomain,frequencyRange] = centeredFFT(yc,Fs);
subplot(5,2,4)
stem(frequencyRange,abs(YfreqDomain));
axis([-(fc+5) (fc+5) 0 1]);
title('Frequency of carrier signal');

%AM Modulation
y_AM = Ac*(A0 + Ka*ym).*yc;
subplot(5,2,5);
plot(t,y_AM);
title ( 'Amplitude Modulated signal');

[YfreqDomain,frequencyRange] = centeredFFT(y_AM,Fs);
subplot(5,2,6)
stem(frequencyRange,abs(YfreqDomain));

%DSB Modulation
y_DSB = ym.*yc;
subplot(5,2,7);
plot(t,y_DSB);
title ( 'Double-sideband Modulated signal');

[YfreqDomain,frequencyRange] = centeredFFT(y_DSB,Fs);
subplot(5,2,8)
stem(frequencyRange,abs(YfreqDomain));
axis([-(fc+fa+5) +(fc+fa+5) 0 0.3]);
title ( 'Frequency of double-sideband Modulated signal');

%SSB Modulation
y_SSB = ym.*yc;
Hd = getHighPassFilter;
y_SSB = filter(Hd,y_SSB);
subplot(5,2,9);
plot(t,y_SSB);
title ( 'Single-sideband Modulated signal');

[YfreqDomain,frequencyRange] = centeredFFT(y_SSB,Fs);
subplot(5,2,10)
stem(frequencyRange,abs(YfreqDomain));
axis([-(fc+fa+5) +(fc+fa+5) 0 0.3]);
title ( 'Frequency of single-sideband Modulated signal');

% Demodulation
figure;

% AM Demodulation
sd = y_AM.*yc*2 - A0;
H_am = demod_filter;
sd = filter(H_am,sd);
subplot(2,2,1);
plot(t,sd);
title('Demodulated and true message signals for AM');

% DSB Demodulation
sd = y_DSB.*yc*2;
H_am = demod_filter;
sd = filter(H_am,sd);
subplot(2,2,2);
plot(t,sd);
title('Demodulated and true message signals for DSB');


% SSB Demodulation
sd = y_SSB.*yc*4;
H_am = demod_filter;
sd = filter(H_am,sd);
subplot(2,2,3);
plot(t,sd);
title('Demodulated and true message signals for SSB');