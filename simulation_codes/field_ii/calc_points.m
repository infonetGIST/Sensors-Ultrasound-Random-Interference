%  Plot the envelope of the pulse-echo field 
%  for a given transducer
%
%  Calling calc_points (Th, points);
%
%  Argument: Th     - Transducer handle
%            points - where the field should be calculated
%
%  Return:   Contour plot of the envelope compressed field
%            with 6 dB between contours.
%
%  Version 1.0, June 23, 1998 by JAJ
%
% Ex: calc_points(Th,[(-10:0.2:10); zeros(1,101); 30*ones(1,101)]'/1000)

function res = calc_points (Th, points)

%  Assumed parameters

fs=100e6;  %  Sampling frequency
c=1540;    %  Speed of sound [m/s]

%  Make the calculation

[p, t]=calc_hhp(Th,Th,points);

%  Find the envelope and make a compression

env=abs(hilbert(p));
env=env/max(max(env));
env=20*log10(env+1e-12);

%  Make the contour plot

[N,M]=size(env);
depth=((1:N)/fs+t)*c/2;
contour(1:M,depth,env,[0:-6:-40]);
