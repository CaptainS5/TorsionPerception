clear all
load('torsionalSaccades.mat')
t_saccades = torsionalSaccades;
t_offset = t_saccades(:,21);
x_offset = t_saccades(:,19);
y_offset = abs(t_saccades(:,20));
figure()

scatter(t_offset,x_offset,'b.')