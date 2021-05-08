close all
clear all

pkg load symbolic;
format long;

%given variables for the primary circuit
f = 50;
Vin = 230;

%attributed values for the secondary circuit
R1 = 8e3;
R2 = 62.84e3;
C = 0.0001;

%printing the variables
printf("Given variables for the primary circuit\n");
printf("Frequency: %e Hz\n", f);
printf("Voltage: %e V\n\n", Vin);
printf("Attributed variables for the secondary circuit\n");
printf("Resistance 1: %e Ohm\n", R1);
printf("Resistance 2: %e Ohm\n", R2);
printf("Capacitor: %e F\n\n", C);

%primary/secondary circuit
n = 11;
Vout = Vin/n;
	
%envelope detector 
t=linspace(0, 10/f, 1000);
w=2*pi*f;
vS = Vout*cos(w*t);
vOhr = zeros(1, length(t));
vOenv = zeros(1, length(t));
	
tOFF = (1/w)*atan(1/(w*R1*C));
vOnexp = Vout*cos(w*tOFF)*exp(-(t-tOFF)/R1/C);
		
for i=1:length(t)
	vOhr(i) = abs(vS(i));
endfor

for i=1:length(t)
	if t(i) < tOFF
	  vOenv(i) = vOhr(i);
	  
	elseif vOnexp(i) > vOhr(i)
	    vOenv(i) = vOnexp(i);
	    
	else
	    tOFF = tOFF + 1/(f*2);
	    vOnexp = Vout*abs(cos(w*tOFF))*exp(-(t-tOFF)/(R1*C));
	    vOenv(i) = vOhr(i);
	 endif 
endfor
	
average_env = mean(vOenv);
ripple_env = max(vOenv) - min(vOenv);
vOenv_medium = (ripple_env/2) + min(vOenv);

printf ("RippleEnvelope = %e \n", ripple_env);
printf ("AverageEnvelope = %e \n\n", average_env);

%voltage regulator
n_diode = 20;
VOn = 0.6;
	
vOreg = zeros(1, length(t));
dc_vOreg = 0;
ac_vOreg = zeros(1, length(t));
	
%dc component regulator
if vOenv_medium >= VOn*n_diode
  dc_vOreg = VOn*n_diode;
else
  dc_vOreg = vOenv_medium;
endif
	
  
%ac component regulator
vt = 0.026;
Is = 1e-14;
eta = 1;

rd = eta*vt/(Is*exp(VOn/(eta*vt)));

ac_vOreg = (n_diode*rd)/((n_diode*rd)+R2)*(vOenv-average_env);

vOreg = dc_vOreg+ac_vOreg;

average_reg = mean(vOreg);
ripple_reg = max(vOreg)-min(vOreg);

printf ("RippleRegulator = %e \n", ripple_reg);
printf ("AverageRegulator= %e \n\n", average_reg);
	
%plots of the values
	
%output voltages at rectifier, envelope detector and regulator
hfc = figure(1);
title("Output voltage of the rectifier regulator and the envelope")
plot (t*1000, vS, ";vo_{rectifier}(t);");
xlabel ("t[ms]")
ylabel ("v_O [Volts]")
legend('Location','northeast');
print (hfc, "vout_rect.eps", "-depsc");

hfc = figure(2);
title("Output voltage of the envelope")
plot (t*1000,vOenv, ";vo_{envelope}(t);");
xlabel ("t[ms]")
ylabel ("v_O [Volts]")
legend('Location','northeast');
print (hfc, "vout_env.eps", "-depsc");

hfc = figure(2);
title("Output voltage of the regulator")
plot (t*1000,vOreg, ";vo_{regulator}(t);");
xlabel ("t[ms]")
ylabel ("v_O [Volts]")
legend('Location','northeast');
print (hfc, "vout_reg.eps", "-depsc");
	
%Deviations (vOenv - 12) 
hfc = figure(4);
title("Defletion from the wanted DC voltage")
plot (t*1000,(vOenv-12), ";vo-12 (t);");
xlabel ("t[ms]")
ylabel ("v_O [Volts]")
legend('Location','northeast');
print (hfc, "defletion.eps", "-depsc");
	
%Merit
total_cost = ((R1+R2)/1000)+C*1000000+((n_diode+4)*0.1);
merit=1/(total_cost*(ripple_reg+abs(average_reg-12)+10e-6));

printf ("Total cost of the components = %e \n", total_cost);
printf ("Merit = %e \n", merit);





