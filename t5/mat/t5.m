close all
clear all

pkg load symbolic;
format long;

%attributed values
R1 = 1e3
R2 = 1e3
R3 = 100e3
R4 = 1e3
C1 = 220e-9
C2 = 110e-9

f = logspace (1,8,70);
w = 2*pi*f;
s = w*j;

Ts = (R1*C1*s)./(1+R1*C1*s).*(1+R3/R4).*(1./(1+R2*C2*s));

%central frequency
wL = 1/(R1*C1); 
wH = 1/(R2*C2);
wO = sqrt(wL*wH); 
sO = j*wO;
centralf = wO/(2*pi);

%low-pass filter
Zc1 = 1/(j*wO*C1);
Zin = R1 + Zc1;

%high-pass filter
Zc2 = 1/(j*wO*C2); 
Zout = R2*Zc2/(R2 + Zc2); 

gaindb = 20.*log10(abs((R1*C1*sO)./(1 + R1*C1*sO).*(1+R3/R4).*1./(1 + R2*C2*sO)));

%printing tables
printf("octave1_TAB\n");
printf("Resistor 1 = %e Ohm\n", R1);
printf("Resistor 2 = %e Ohm\n", R2);
printf("Resistor 3 = %e Ohm\n", R3);
printf("Resistor 4 = %e Ohm\n", R4);
printf("Capacitor 1 = %e F\n", C1);
printf("Capacitor 2 = %e F\n", C2);
printf("octave1_END\n\n");

printf("octave2_TAB\n");
printf("Input Impedance = %e\n", Zin);
printf("Output Impedance = %e\n", Zout);
printf("Central Frequency = %e\n", centralf);
printf("Obtained gain (in decibels) = %e dB\n", gaindb);
printf("octave2_END\n\n");

%printing figures
figure1 = figure();
semilogx(f,20*log10(abs(Ts)));
xlabel("Frequency [Hz]");
ylabel("Gain [dB]");
title("Gain obtained");
print(figure1, "octave1.eps", "-depsc");

figure1 = figure();
semilogx(f,180*arg(Ts)/pi);
xlabel("Frequency [Hz]");
ylabel("Phase [Degrees]");
title("Phase frequency response");
print(figure1, "octave2.eps", "-depsc");
