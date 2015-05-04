close all; clear all; clc;


%% create a sample plot for demo 
figure;
plot(rand(1,10));


%% call the function to place down the rectangle and axes 
[rect, zoomedAxes] = addZoomInAxes(gca);


%% can further style rect and zoomedAxes as needed 


