close all
clear all

pkg load symbolic;
format long;

%given values
f = 1000; %valores aleatórios
vin = 230; %nao sei bem o que fazer

%attributed values
R1 = 1e3;
R2 = 100e3;
R3 = 100e3;
R4 = 1e3;
C1 = 220e-9;
C2 = 1e-6;

wL = 1/(R1*C1); %low-pass frequency (?)
wH = 1/(R2*C2); %high-pass freqeuncy (?)
wO = sqrt(wL*wH); %media

%high-pass filter
Zc1 = 1/(j*wO*C1); %Impedancia do condensador 1
v_plus = vin*Zc1/(Zc1 + R1); %voltagem depois do filtro

Zin = R1 + Zc1; %Impedancia do inicio

%OpAmp
v_minus = v_plus; %Slide 6 aula 23
vO = v_minus*(R4 + R3)/R3; %Slide 6 aula 23

%low-pass filter
Zc2 = 1/(j*wO*C2); %Impedancia do condensador 2
vout = vO*Zc2/(R2 + Zc2); %voltagem depois do filtro

Zout = R2*Zc2/(R2 * Zc2); %Impedancia do inicio

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
printf("octave2_END\n\n");
