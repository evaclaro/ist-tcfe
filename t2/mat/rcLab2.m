close all
clear all
format long e

pkg load symbolic
 
values = dlmread('data.txt');


#Declaration of the values given by the python script on IS units
R1 = values(3,4)e03;
R2 = values(4,3)e03;
R3 = values(5,3)e03;
R4 = values(6,3)e03;
R5 = values(7,3)e03;
R6 = values(8,3)e03;
R7 = values(9,3)e03;
Vs = values(10,3);
C = values(11,3)e-06;
Kb = values(12,3)e-03;
Kd = values(13,3)e03;

#Calculation of the conductance of each resistor of the circuit
G1=1/R1;
G2=1/R2;
G3=1/R3;
G4=1/R4;
G5=1/R5;
G6=1/R6;
G7=1/R7;


#FirstPoint
#Matrix of the mesh method and additional equations for t<0
A_1 = [1,0,0,0,0,0,0,0;...
       0,1,0,0,0,0,0,0;...
       0,G1,-G1-G2-G3,G2,G3,0,0,0;...
       0,0,Kb+G2,-G2,-Kb,0,0,0;...
       0,-G1,G1,0,G4,0,G6,0;...
       0,0,Kb,0,-Kb+G5,-G5,0,0;...
       0,0,0,0,0,0,-G6-G8,G8;...
       0,0,0,0,1,0,Kd*G6,-1];

#Matrix of the results
B_1 = [0;Vs;0;0;0;0;0;0];

#Matrix of the voltage values
V_1 = A_1\B_1;

#Atribuitions of the values to the variables
V0_i = V_1(1,1);
V1_i = V_1(2,1);
V2_i = V_1(3,1);
V3_i = V_1(4,1);
V5_i = V_1(5,1);
V6_i = V_1(6,1);
V7_i = V_1(7,1);
V8_i = V_1(8,1);

#Calculation of the current values of Ib, in each resistor and in the voltage sources
Ib = Kb*(V2_i - V5_i);
IR1_i = G1*(V2_i-V1_i);
IR2_i = G2*(V3_i-V2_i);
IR3_i = G3*(V2_i-V5_i);
IR4_i = G4*(-V5_i);
IR5_i = G5*(V5_i-V6_i);
IR6_i = G6*(-V7_i);
IR7_i = G1*(V7_i-V8_i);
Ivs_i = IR1_i;
IVd_i = IR3_i+IR4_i-IR5_i;


#SecondPoint
#Calculation of Vx
Vx = V6_i - V8_i;

#Matrix of the mesh method and additional equations for t=0
A_2 = [1,0,0,0,0,0,0,0;...
       0,1,0,0,0,0,0,0;...
       0,G1,-G1-G2-G3,G2,G3,0,0,0;...
       0,0,Kb+G2,-G2,-Kb,0,0,0;...
       0,0,G1,0,G4,0,G6,0;...
       0,0,0,0,0,1,0,-1;...
       0,0,0,0,0,0,-G6-G8,G8;...
       0,0,0,0,1,0,Kd*G6,-1];
       
#Matrix of the results
B_2 = [0;0;0;0;0;Vx;0;0];

#Matrix of the voltage values
V_2 = A_2\B_2;

#Atribuitions of the values to the variables
V0_t0 = V_1(1,1);
V1_t0 = V_1(2,1);
V2_t0 = V_1(3,1);
V3_t0 = V_1(4,1);
V5_t0 = V_1(5,1);
V6_t0 = V_1(6,1);
V7_t0 = V_1(7,1);
V8_t0 = V_1(8,1);

#Calculation of the current values of Ib, in each resistor and in the voltage sources
Ib = Kb*(V2_t0 - V5_t0);
IR1_t0 = G1*V2_t0;
IR2_t0 = G2*(V3_t0-V2_t0);
IR3_t0 = G3*(V2_t0-V5_t0);
IR4_t0 = G4*(-V5_t0);
IR5_t0 = G5*(V5_t0-V6_t0);
IR6_t0 = G6*(-V7_t0);
IR7_t0 = G1*(V7_t0-V8_t0);
Ivs_t0 = IR1_t0;
IVd_t0 = IR3_t0+IR4_t0-IR5_t0;

#Calculation of Ix, Req, and tau values
Ix_t0 = -Kb*(V2_t0 - V5_t0) - G5*(V6_t0-V5_t0);
Req_t0 = abs(Vx/Ix_t0);
tau = Req_t0*C;
