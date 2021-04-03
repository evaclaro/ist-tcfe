close all
clear all
format long e

pkg load symbolic
 
values = dlmread('data.txt');

%Declaration of the values given by the python script
R1 = values(3,4);
R2 = values(4,3);
R3 = values(5,3);
R4 = values(6,3);
R5 = values(7,3);
R6 = values(8,3);
R7 = values(9,3);
Vs = values(10,3);
C = values(11,3);
Kb = values(12,3);
Kd = values(13,3);
Vx = 8.764397;%calculado no octave depois

%PERGUNTA 1 
file = fopen('pergunta1.txt', 'w');

fprintf (file, "R1 N2 N1 %.11fk\n", R1);
fprintf (file, "R2 N3 N2 %.11fk\n", R2);
fprintf (file,"R3 N2 N5 %.11fk\n", R3);
fprintf (file, "R4 0 N5 %.11fk\n", R4);
fprintf (file, "R5 N5 N6 %.11fk\n", R5);
fprintf (file, "R6 0 N7 %.11fk\n", R6);
fprintf (file, "R7 N9 N8 %.11fk\n", R7);
fprintf (file, "Vs N1 0  %.11f\n", Vs);
fprintf (file, "C N6 N8 %.11fuF\n", C);
fprintf (file, "Gb N6 N3 N2 N5 %.11fm\n", Kb);
fprintf (file, "Hd N5 N8 Vaux %.11fk\n", Kd);
fprintf (file, "Vaux N7 N9 DC 0\n");


fclose(file);

movefile('pergunta1.txt', '../sim');


%PERGUNTA 2 
file = fopen('pergunta2.txt', 'w');

fprintf (file, "R1 N2 N1 %.11fk\n", R1);
fprintf (file, "R2 N3 N2 %.11fk\n", R2);
fprintf (file,"R3 N2 N5 %.11fk\n", R3);
fprintf (file, "R4 0 N5 %.11fk\n", R4);
fprintf (file, "R5 N5 N6 %.11fk\n", R5);
fprintf (file, "R6 0 N7 %.11fk\n", R6);
fprintf (file, "R7 N9 N8 %.11fk\n", R7);
fprintf (file, "Vs N1 0 0\n");
fprintf (file, "Vx N6 N8 %.11f\n", Vx);
fprintf (file, "Gb N6 N3 N2 N5 %.11fm\n", Kb);
fprintf (file, "Hd N5 N8 Vaux %.11fk\n", Kd);
fprintf (file, "Vaux N7 N9 DC 0\n");

fclose(file);

movefile('pergunta2.txt', '../sim');


%PERGUNTA 3 
file = fopen('pergunta3.txt', 'w');

fprintf (file, "R1 N2 N1 %.11fk\n", R1);
fprintf (file, "R2 N3 N2 %.11fk\n", R2);
fprintf (file,"R3 N2 N5 %.11fk\n", R3);
fprintf (file, "R4 0 N5 %.11fk\n", R4);
fprintf (file, "R5 N5 N6 %.11fk\n", R5);
fprintf (file, "R6 0 N7 %.11fk\n", R6);
fprintf (file, "R7 N9 N8 %.11fk\n", R7);
fprintf (file, "Vs N1 0 0\n");
fprintf (file, "C N6 N8 %.11fuF\n", C);
fprintf (file, "Gb N6 N3 N2 N5 %.11fm\n", Kb);
fprintf (file, "Hd N5 N8 Vaux %.11fk\n", Kd);
fprintf (file, "Vaux N7 N9 DC 0\n");
fprintf (file, ".IC v(N6)=8.764397 v(N8)=1.776357e-15\n");%%%atencaoooooo

fclose(file);

movefile('pergunta3.txt', '../sim');


%PERGUNTA 4 
file = fopen('pergunta4e5.txt', 'w');

fprintf (file, "R1 N2 N1 %.11fk\n", R1);
fprintf (file, "R2 N3 N2 %.11fk\n", R2);
fprintf (file,"R3 N2 N5 %.11fk\n", R3);
fprintf (file, "R4 0 N5 %.11fk\n", R4);
fprintf (file, "R5 N5 N6 %.11fk\n", R5);
fprintf (file, "R6 0 N7 %.11fk\n", R6);
fprintf (file, "R7 N9 N8 %.11fk\n", R7);
fprintf (file, "Vs N1 0 0.0 ac 1.0 sin(0 .1 1000)\n");
fprintf (file, "C N6 N8 %.11fuF\n", C);
fprintf (file, "Gb N6 N3 N2 N5 %.11fm\n", Kb);
fprintf (file, "Hd N5 N8 Vaux %.11fk\n", Kd);
fprintf (file, "Vaux N7 N9 DC 0\n");
fprintf (file, ".IC v(N6)=8.764397 v(N8)=1.776357e-15\n");

fclose(file);

movefile('pergunta4e5.txt', '../sim');




