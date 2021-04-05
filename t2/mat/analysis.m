close all
clear all
format long e

pkg load symbolic
 
values = dlmread('data.txt');

%Declaration of the values given by the python script
R1 = values(3,4)*1000;
R2 = values(4,3)*1000;
R3 = values(5,3)*1000;
R4 = values(6,3)*1000;
R5 = values(7,3)*1000;
R6 = values(8,3)*1000;
R7 = values(9,3)*1000;
Vs = values(10,3);
C = values(11,3)/1000000;
Kb = values(12,3)/1000;
Kd = values(13,3)*1000;

#Calculation of the conductance of each resistor of the circuit
G1=1/R1;
G2=1/R2;
G3=1/R3;
G4=1/R4;
G5=1/R5;
G6=1/R6;
G7=1/R7;



#------------------------------------------------------------Alínea 1--------------------------------------------------------------------
#FirstPoint
printf ("\n\nPARTE 1\n");
#Matrix of the nodal method and additional equations for t<0
A_1 = [1,0,0,0,0,0,0,0;...
       0,1,0,0,0,0,0,0;...
       0,G1,-G1-G2-G3,G2,G3,0,0,0;...
       0,0,Kb+G2,-G2,-Kb,0,0,0;...
       0,-G1,G1,0,G4,0,G6,0;...
       0,0,Kb,0,-Kb-G5,G5,0,0;...
       0,0,0,0,0,0,-G6-G7,G7;...
       0,0,0,0,1,0,Kd*G6,-1];

#Matrix of the results
B_1 = [0;Vs;0;0;0;0;0;0];

#Matrix of the voltage values
V_1 = A_1\B_1;

#Atribuitions of the values to the variables
printf ("octave1v_TAB\n");
V0i = V_1(1,1)
V1i = V_1(2,1)
V2i = V_1(3,1)
V3i = V_1(4,1)
V5i = V_1(5,1)
V6i = V_1(6,1)
V7i = V_1(7,1)
V8i = V_1(8,1)
printf ("octave1v_END\n");

#Calculation of the current values of Ib, in each resistor and in the voltage sources
printf ("octave1i_TAB\n")
Ib = Kb*(V2i - V5i)
IR1i = G1*(V2i-V1i)
IR2i = G2*(V3i-V2i)
IR3i = G3*(V2i-V5i)
IR4i = G4*(-V5i)
IR5i = G5*(V5i-V6i)
IR6i = G6*(-V7i)
IR7i = G7*(V7i-V8i);
Ivsi = IR1i
IVdi = IR3i+IR4i-IR5i
printf ("octave1i_END\n");



#------------------------------------------------------------Alínea 2--------------------------------------------------------------------
#SecondPoint
printf ("\n\nPARTE 2\n");
#Calculation of Vx
Vx = V6i - V8i;

#Matrix of the nodal method and additional equations for t=0
A_2 = [1,0,0,0,0,0,0,0;...
       0,1,0,0,0,0,0,0;...
       0,0,-G1-G2-G3,G2,G3,0,0,0;...
       0,0,Kb+G2,-G2,-Kb,0,0,0;...
       0,0,G1,0,G4,0,G6,0;...
       0,0,0,0,0,1,0,-1;...
       0,0,0,0,0,0,-G6-G7,G7;...
       0,0,0,0,1,0,Kd*G6,-1];
       
#Matrix of the results
B_2 = [0;0;0;0;0;Vx;0;0];

#Matrix of the voltage values
V_2 = A_2\B_2;

#Atribuitions of the values to the variables
printf ("octave2v_TAB\n");
V0t0 = V_2(1,1)
V1t0 = V_2(2,1)
V2t0 = V_2(3,1)
V3t0 = V_2(4,1)
V5t0 = V_2(5,1)
V6t0 = V_2(6,1)
V7t0 = V_2(7,1)
V8t0 = V_2(8,1)
printf ("octave2v_END\n");

x1 = V6t0;
x2 = V8t0;

#Calculation of the current values of Ib, in each resistor and in the voltage sources
printf ("octave2i_TAB\n");
Ib = Kb*(V2t0 - V5t0)
IR1t0 = G1*V2t0
IR2t0 = G2*(V3t0-V2t0)
IR3t0 = G3*(V2t0-V5t0)
IR4t0 = G4*(-V5t0)
IR5t0 = G5*(V5t0-V6t0)
IR6t0 = G6*(-V7t0)
IR7t0 = G7*(V7t0-V8t0)
Ivst0 = IR1t0
IVdt0 = IR3t0+IR4t0-IR5t0
printf ("octave2i_END\n");

#Calculation of Ix, Req, and tau values
printf ("octave2valores_TAB\n");
Ixt0 = -Kb*(V2t0 - V5t0) - G5*(V6t0-V5t0)
Reqt0 = abs(Vx/Ixt0)
tau = Reqt0*C
printf ("octave2valores_END\n");



#------------------------------------------------------------Alínea 3--------------------------------------------------------------------
#ThirdPoint
printf ("\n\nPARTE 3\n");
#Defining the time interval and variables
tempo = 0:(20e-3)/1000:20e-3;

V6Nt = (V6t0)*e.^(-tempo/tau);

natural = figure ();

plot(tempo*1000,V6Nt)

xlabel ("t[ms]");
ylabel ("V6(t) [V]");
print (natural, "natural.eps", "-depsc");
hold off


#------------------------------------------------------------Alínea 4--------------------------------------------------------------------
#FourthPoint
printf ("\n\nPARTE 4\n");
#Declaring variables
f=1000;
w=2*pi*f;
Zc=1/(j*w*C);

A_4 = [-G1, G1 + G2 + G3, -G2, -G3, 0, 0, 0;
    0, -G2 - Kb, G2, Kb, 0, 0, 0;
    0, Kb, 0, -Kb - G5, G5 + 1/Zc , 0, -1/Zc;
    0, 0, 0, 0, 0, G6 + G7, -G7;
    1, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 1, 0, Kd * G6, -1;
    G1, -G1, 0, -G4, 0, -G6, 0];
    
B_4 =[0; 0; 0; 0; 1; 0; 0];

V_4 = A_4\B_4;

for a=1:length(V_4)
  x= imag(V_4(a))/real(V_4(a));
  phi(a)= atan(x);
endfor

#Atribuitions of the values to the variables
printf ("octave4v_TAB\n");
V0 = 0;
V1 = abs(V_4(1))
V2 = abs(V_4(2))
V3 = abs(V_4(3))
V5 = abs(V_4(4))
V6 = abs(V_4(5))
V7 = abs(V_4(6))
V8 = abs(V_4(7))
printf ( "octave4v_END\n");

printf ("octave4p_TAB\n");
Phase0 = 0;
Phase1 = phi(1)
Phase2 = phi(2)
Phase3 = phi(3)
Phase5 = phi(4)
Phase6 = phi(5)
Phase7 = phi(6)
Phase8 = phi(7)
printf ("octave4p_END\n");



#------------------------------------------------------------Alínea 5--------------------------------------------------------------------
#FifthPoint
printf ("\n\nPARTE 5\n");
t=-5e-3:1e-6:20e-3;
V6all(t>=0)= V_4(6)*sin(2*pi*f*t(t>=0)) + Vx*exp(-t(t>=0)/tau);
V6all(t<0) = V6i;
Vsall(t>=0) = sin(2*pi*f*t(t>=0));
Vsall(t<0) = Vs;
 
hf2 = figure();
plot(t, V6all, t, Vsall);
xlabel ("t[ms]");
ylabel ("v_6(t) [V] and v_s(t) [V]");
legend("v6","vs");
#title ("Final solution of v_6(t) and v_s(t) in the interval [-5,20]ms");
print (hf2, "theoretical_5.eps", "-color");
close(hf2);
hold off


#------------------------------------------------------------Alínea 6--------------------------------------------------------------------
#SixthPoint
printf ("\n\nPARTE 6\n");

#Creation of the needed variables
phasor_vs = 1*power(e,-i*pi/2);
f_6 = -1:1e-03:6; 
W = 2*pi*power(10,f_6);
Y_c = i .* W .* C;
Z_c = 1. ./Y_c;

#Matrix of the nodal method for the voltages that don't depend on the frequency (V2, V3, V5, V7)
A_6 = [-G3+Kb,  0, -Kb+G3+G4, G6;
       Kb + G2, -G2, -Kb, 0;         
       -Kb+G1+G3, 0, -G3+Kb, 0;
       0, 0, 1, Kd*G6-R7*G6-1]; 
       
#Matrix of the results
B_6 = [0; 0; phasor_vs * G1; 0];

#Matrix of the results (V2, V3, V5, V7)
V_6=A_6\B_6; 

#Atribuitions of the values to the variables
V2_ph = V_6(1,1)
V3_ph = V_6(2,1)
V5_ph = V_6(3,1)
V7_ph = V_6(4,1)

#Calculation of the voltages v6 and v8 and the voltage source vs and the voltage of the capacitor C
v8_ph = R7*(G1+G6)*V7_ph + 0*Z_c;
v6_ph = ((G5+Kb)*V5_ph-Kb*V2_ph+ (v8_ph ./ Z_c)) ./ (G5 + 1. ./ Z_c);
vc_ph = v6_ph - v8_ph;
vs_ph = power(e,i*pi/2) + 0*W;

#Definition of the phase of v6 in degrees
phase_v6_ph = 180/pi*(angle(v6_ph)); 

#Ensuring that the angle is in the range of -90 to 90 degrees
for  var=1:length(phase_v6_ph)
	if(phase_v6_ph(var)<= -90) 
		phase_v6_ph(var) = phase_v6_ph(var) + 180;
	elseif (phase_v6_ph(var)>= 90) 
		phase_v6_ph(var) = phase_v6_ph(var) - 180;
endif
endfor

#Creation of the graphic for the phases of v6, vc and vs in degrees
hg = figure ();
plot (f_6, phase_v6_ph, "y");
hold on;
plot (f_6, 180/pi*(angle(vc_ph) + pi), "m");
hold on;
plot (f_6, (180*angle(vs_ph))/pi, "c");

legend("v6","vc","vs");
xlabel ("log_{10}(f) [Hz]");
ylabel ("Phase v_c(f), v_6(f), v_s(f) [degrees]");
print (hg, "../mat/Phase(degrees).eps");
hold off

#Creation of the graphic for the magnitude of v6, vc and vs in Hertz
hj = figure ();
plot (f_6, 20*log10(abs(v6_ph)), "y");
hold on;
plot (f_6, 20*log10(abs(vs_ph)), "m");
hold on;
plot (f_6, 20*log10(abs(vc_ph)), "c");

legend("v6","vs","vc");
xlabel ("log_{10}(f) [Hz]");
ylabel ("Magnitude v_c, v_6, v_s [dB]");
print (hj, "../mat/MagnitudedB.eps");
hold off


#-------------------------------------------------------------Ngspice--------------------------------------------------------------------
#Move the data to ngspice
#Question 1 
file = fopen('pergunta1.txt', 'w');

fprintf (file, "R1 N2 N1 %.11e\n", R1);
fprintf (file, "R2 N3 N2 %.11e\n", R2);
fprintf (file, "R3 N2 N5 %.11e\n", R3);
fprintf (file, "R4 0 N5 %.11e\n", R4);
fprintf (file, "R5 N5 N6 %.11e\n", R5);
fprintf (file, "R6 0 N7 %.11e\n", R6);
fprintf (file, "R7 N9 N8 %.11e\n", R7);
fprintf (file, "Vs N1 0  DC %.11e\n", Vs);
fprintf (file, "C N6 N8 %.11e\n", C);
fprintf (file, "Gb N6 N3 N2 N5 %.11e\n", Kb);
fprintf (file, "Hd N5 N8 Vaux %.11e\n", Kd);
fprintf (file, "Vaux N7 N9 DC 0\n");

fclose(file);

movefile('pergunta1.txt', '../sim');


#Question 2
file = fopen('pergunta2.txt', 'w');

fprintf (file, "R1 N2 N1 %.11e\n", R1);
fprintf (file, "R2 N3 N2 %.11e\n", R2);
fprintf (file, "R3 N2 N5 %.11e\n", R3);
fprintf (file, "R4 0 N5 %.11e\n", R4);
fprintf (file, "R5 N5 N6 %.11e\n", R5);
fprintf (file, "R6 0 N7 %.11e\n", R6);
fprintf (file, "R7 N9 N8 %.11e\n", R7);
fprintf (file, "Vs N1 0 DC 0\n");
fprintf (file, "Vx N6 N8 %.11e\n", Vx);
fprintf (file, "Gb N6 N3 N2 N5 %.11e\n", Kb);
fprintf (file, "Hd N5 N8 Vaux %.11e\n", Kd);
fprintf (file, "Vaux N7 N9 DC 0\n");

fclose(file);

movefile('pergunta2.txt', '../sim');


#Question 3
file = fopen('pergunta3.txt', 'w');

fprintf (file, "R1 N2 N1 %.11e\n", R1);
fprintf (file, "R2 N3 N2 %.11e\n", R2);
fprintf (file, "R3 N2 N5 %.11e\n", R3);
fprintf (file, "R4 0 N5 %.11e\n", R4);
fprintf (file, "R5 N5 N6 %.11e\n", R5);
fprintf (file, "R6 0 N7 %.11e\n", R6);
fprintf (file, "R7 N9 N8 %.11e\n", R7);
fprintf (file, "Vs N1 0 0\n");
fprintf (file, "C N6 N8 %.11e\n", C);
fprintf (file, "Gb N6 N3 N2 N5 %.11e\n", Kb);
fprintf (file, "Hd N5 N8 Vaux %.11e\n", Kd);
fprintf (file, "Vaux N7 N9 DC 0\n");
fprintf (file, ".IC v(N6)=%e v(N8)=%e\n", x1, x2);%atencaoooooooooooooooooooo

fclose(file);

movefile('pergunta3.txt', '../sim');


#Question 4 e 5
file = fopen('pergunta4e5.txt', 'w');

fprintf (file, "R1 N2 N1 %.11e\n", R1);
fprintf (file, "R2 N3 N2 %.11e\n", R2);
fprintf (file, "R3 N2 N5 %.11e\n", R3);
fprintf (file, "R4 0 N5 %.11e\n", R4);
fprintf (file, "R5 N5 N6 %.11e\n", R5);
fprintf (file, "R6 0 N7 %.11e\n", R6);
fprintf (file, "R7 N9 N8 %.11e\n", R7);
fprintf (file, "Vs N1 0 0.0 ac 1.0 sin(0 1 1000)\n");
fprintf (file, "C N6 N8 %.11e\n", C);
fprintf (file, "Gb N6 N3 N2 N5 %.11e\n", Kb);
fprintf (file, "Hd N5 N8 Vaux %.11e\n", Kd);
fprintf (file, "Vaux N7 N9 DC 0\n");
fprintf (file, ".IC v(N6)=%e v(N8)=%e\n", x1, x2);%atencaoooo

fclose(file);

movefile('pergunta4e5.txt', '../sim');



