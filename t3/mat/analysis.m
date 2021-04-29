close all
clear all

pkg load symbolic;
format long;

%chosen variable values
R1 = 8e3
R2 = 62.84e3
C = 0.0001

printf ("values_chosen_TAB\n");
printf ("R1 = %e \n", R1);
printf ("R2 = %e \n", R2);
printf ("C = %e \n", C);
printf ("values_chosen_END\n\n");

%variables
f=50;
Vp = 230;

%primary/secondary circuit
n = 11;
Vs = Vp/n;
	
%envelope detector 
t=linspace(0, 10/f, 1000);
w=2*pi*f;
vs = Vs * cos(w*t);
vr = zeros(1, length(t));
vOenv = zeros(1, length(t));
	
tOFF = 1/w * atan(1/w/R1/C);
vOnexp = Vs*cos(w*tOFF)*exp(-(t-tOFF)/R1/C);

figure 1
		
for i=1:length(t)
	vr(i) = abs(vs(i));
endfor

for i=1:length(t)
	if t(i) < tOFF
	  vOenv(i) = vr(i);
	  elseif vOnexp(i) > vr(i)
	    vOenv(i) = vOnexp(i);
	  else
	    tOFF = tOFF + 1/f/2;
	    vOnexp = Vs*abs(cos(w*tOFF))*exp(-(t-tOFF)/R1/C);
	    vOenv(i) = vr(i);
	 endif
endfor
	
average = mean(vOenv)
ripple_env = max(vOenv) - min(vOenv)
average_env = ripple_env/2 + min(vOenv)

printf ("envelope_TAB\n");
printf ("RippleEnvelope = %e \n", ripple_env);
printf ("AverageEnvelope = %e \n", average_env);
printf ("envelope_END\n\n");

%voltage regulator -----------------------------------------
num_diodes = 20
von = 0.6;
	
vOreg = zeros(1, length(t));
dc_vOreg = 0;
ac_vOreg = zeros(1, length(t));
	
%dc component regulator ----------------
if average_env >= von*num_diodes
  dc_vOreg = von*num_diodes;
else
  dc_vOreg = average_env;
endif
	
  
%ac component regulator -----------------
vt = 0.025;
Is = 1e-14;
mat_sil = 1;

rd = mat_sil*vt/(Is*exp(von/(mat_sil*vt)))
ac_vOreg = num_diodes*rd/(num_diodes*rd+R2) * (vOenv-average_env);
vOreg = dc_vOreg + ac_vOreg;

	
%plots
	
%output voltages at rectifier, envelope detector and regulator
hfc = figure(1);
title("Regulator and envelope output voltage v_o(t)")
plot (t*1000, vr, ";vo_{rectifier}(t);", t*1000,vOenv, ";vo_{envelope}(t);", t*1000,vOreg, ";vo_{regulator}(t);");
xlabel ("t[ms]")
ylabel ("v_O [Volts]")
legend('Location','northeast');
print (hfc, "all_vout.eps", "-depsc");
	
%Deviations (vOenv - 12) 
hfc = figure(2);
title("Deviations from desired DC voltage")
plot (t*1000,vOenv-12, ";vo-12 (t);");
xlabel ("t[ms]")
ylabel ("v_O [Volts]")
legend('Location','northeast');
print (hfc, "deviation.eps", "-depsc");
	

average_reg = mean(vOreg)
ripple_reg = max(vOreg)-min(vOreg)

printf ("regulator_TAB\n");
printf ("RippleRegulator = %e \n", ripple_reg);
printf ("AverageRegulator= %e \n", average_reg);
printf ("regulator_END\n\n");

cost = R1/1000 + R2/1000 + C*1e6 + 0.4 + num_diodes*0.1 
MERIT= 1/ (cost* (ripple_reg + abs(average_reg-12) + 10e-6))

printf ("merit_TAB\n");
printf ("Cost = %e \n", cost);
printf ("Merit= %e \n", MERIT);
printf ("merit_END\n\n");
