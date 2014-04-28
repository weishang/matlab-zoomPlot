close all; clear all; clc;

figure; 
t = 0:0.001:0.1;
plot(t, cos(2*pi*50*t)); 
xlabel('time t (s)');
ylabel('cos(2 \pi 50 t)');
ah = gca; 
% location of the plot to be zoomed in.  
s_pos =[0.05 0 0.06 0.1];
% location of the zoom-in plot  
t_pos = [0.035 0.4 0.065 0.7];    

% generate a zoom-in plot.  
az = zoomPlot(ah, s_pos, t_pos);     

% can manipulate the added axes 
% xlabel(az,'time (s)');
