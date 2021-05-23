%gain stage

VT=25e-3;
BFN=178.7;
VAFN=69.7;
RE1=100;
RC1=1000;
RB1=78000;
RB2=18000;
VBEON=0.7;
VCC=12;
RS=100;
C1 =450e-06;
C2 =450e-06;
Cout = 200e-6;
vi = 0.01;

printf("valores_intro_TAB\n");
printf("Cin = %e \n", C1);
printf("CE = %e \n", C2);
printf("Cout = %e \n", Cout);
printf("R1 = %e \n", RB1);
printf("R2 = %e \n", RB2);
printf("RC = %e \n", RC1);
printf("RE = %e \n", RE1);
printf("Rout = %e \n", RE1);
printf("valores_intro_END\n\n");

i = complex(0,1);
f = logspace(1,8, 100);
w = 2*pi*f;


RB=1/(1/RB1+1/RB2)
VEQ=RB2/(RB1+RB2)*VCC
IB1=(VEQ-VBEON)/(RB+(1+BFN)*RE1)
IC1=BFN*IB1
IE1=(1+BFN)*IB1
VE1=RE1*IE1
VO1=VCC-RC1*IC1
VCE=VO1-VE1


gm1=IC1/VT
rpi1=BFN/gm1
ro1=VAFN/IC1
Zc1 = 1./(i*w*C1);
Zc2 = 1./(i*w*C2);

I=ones(length(w),4);
voE=zeros(1,length(w));
AV1=zeros(1,length(w));

for k=1:length(w)
A = [0, -RB, 0, 0, RS+RB;
    -RE1, -Zc2(k), 0, RE1 + Zc2(k), 0; 
    RE1 + ro1 + RC1, 0, -ro1, -RE1, 0;
    0, gm1*rpi1, 1, 0, 0;
    0, RB+Zc1(k)+rpi1+Zc2(k), 0, -Zc2(k), -RB];

N = [vi; 0; 0; 0; 0];
res = A\N;

voE(k) = abs(RC1 * res(1));
AV1(k) = voE(k)/vi;
endfor

ZI1 = 1/(1/RB + 1/rpi1);
ZO1 = 1/(1/ro1 + 1/RC1);



%//////////////////OUTPUT STAGE/////////////////////%
BFP = 227.3
VAFP = 37.2
RE2 = 100
VEBON = 0.7
VI2 = VO1
IE2 = (VCC-VEBON-VI2)/RE2
IC2 = BFP/(BFP+1)*IE2
VO2 = VCC - RE2*IE2

gm2 = IC2/VT
go2 = IC2/VAFP
gpi2 = gm2/BFP
ge2 = 1/RE2

ro2 = 1/go2;
rpi2 = 1/gpi2;

I2=zeros(length(w),3);
vo2=zeros(1,length(w));
AV2 = zeros(1,length(w));

for k=1:length(w)
A2 = [rpi2+RE2, -RE2, 0;
    gm2*rpi2, 0, 1; 
    -RE2, RE2+ro2, -ro2];

N2 = [voE(k); 0; 0];
res = A2\N2;

vo2(k) = abs((res(1)-res(2))*RE2);
AV2(k) = vo2(k)/voE(k);
endfor


ZI2 = (gm2+gpi2+go2+ge2)/gpi2/(gpi2+go2+ge2);
ZO2 = 1/(gm2+gpi2+go2+ge2);
ZO = 1/(gm2*(rpi2/(rpi2+ZO1))+(1/(rpi2+ZO1))+go2+ge2);
AV = AV1.*AV2;


%%%%%%PLOT%%%%%%%
theo = figure ();
plot (log10(f), 20*log10(AV), "g");
legend("v_o(f)/v_i(f)");
xlabel ("Frequency [Hz]");
ylabel ("Gain");
print (theo, "theo", "-depsc");
%%%%%%% end plot %%%%%%%%

AVdb = 20*log10(AV);
maximo = max(AVdb);
k = 1;

while  0.05 < ((maximo - AVdb(k))/maximo)
    k = k + 1;
endwhile

lowerCutoff = (w(k))/(2*pi);
highCutoff = 10^7;

bandwidth = highCutoff - lowerCutoff;
cost = 1e-3*(RE1 + RC1 + RB1 + RB2 + RE2) + 1e6*(C1 + C2) + 2*0.1;

AV=abs(AV);
Merit = (max(AV) * bandwidth)/(cost * lowerCutoff)

printf ("ponto1_TAB\n");
printf ("IB1 = %e \n", IB1);
printf ("IC1 = %e \n", IC1);
printf ("IE1 = %e \n", IE1);
printf ("cost= %e \n", cost);
printf ("VO1 = %e \n", VO1);
printf ("ponto1_END\n\n");



printf ("Z_TAB\n");
printf (" Imput impedance (Gain stage)- ZI1 = %e Ohm \n", ZI1);
printf ("Output impedance (Gain stage)-ZO1 = %e Ohm \n", ZO1);
printf (" Imput impedance (Output stage)-ZI2 = %e Ohm \n", ZI2);
printf ("Output impedance (Output stage)-- ZO2 = %e Ohm \n", ZO2);
printf ("Output impedance-ZO = %e \n", ZO);
printf ("Z_END\n\n");

printf ("r_theo_TAB\n");
printf ("Gain stage- AV1  = %e V\n", max(AV1));
printf ("Output stage stage -AV2 = %e V \n", max(AV2));
printf ("Bandwidth= %e Hz \n", bandwidth);
printf ("Cut Off Frequency= %e Hz \n", lowerCutoff);
printf ("r_theo_END\n\n");

