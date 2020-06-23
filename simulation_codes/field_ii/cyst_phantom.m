%  Create a computer model of a cyst phantom. The phantom contains
%  fiven point targets and 6, 5, 4, 3, 2 mm diameter waterfilled cysts, 
%  and 6, 5, 4, 3, 2 mm diameter high scattering regions. All scatterers 
%  are situated in a box of (x,y,z)=(50,10,60) mm and the box starts 
%  30 mm from the transducer surface.
%
%  Calling: [positions, amp] = cyst_phantom (N);
%
%  Parameters:  N - Number of scatterers in the phantom
%
%  Output:      positions  - Positions of the scatterers.
%               amp        - amplitude of the scatterers.
%
%  Version 2.2, April 2, 1998 by Joergen Arendt Jensen

function [positions, amp] = cyst_phantom (N)

x_size = 50/1000;   %  Width of phantom [mm]
y_size = 10/1000;   %  Transverse width of phantom [mm]
z_size = 60/1000;   %  Height of phantom [mm]
z_start = 30/1000;  %  Start of phantom surface [mm];

%  Create the general scatterers

x = (rand (N,1)-0.5)*x_size;
y = (rand (N,1)-0.5)*y_size;
z = rand (N,1)*z_size + z_start;

%  Generate the amplitudes with a Gaussian distribution

amp=randn(N,1);

%  Make the cyst and set the amplitudes to zero inside

%  6 mm cyst
r=6/2/1000;      %  Radius of cyst [mm]
xc=10/1000;     %  Place of cyst [mm]
zc=10/1000+z_start;  

inside = ( ((x-xc).^2 + (z-zc).^2) < r^2);
amp = amp .* (1-inside); 

%  5 mm cyst
r=5/2/1000;      %  Radius of cyst [mm]
zc=20/1000+z_start;  

inside = ( ((x-xc).^2 + (z-zc).^2) < r^2);
amp = amp .* (1-inside); 

%  4 mm cyst
r=4/2/1000;      %  Radius of cyst [mm]
zc=30/1000+z_start;  

inside = ( ((x-xc).^2 + (z-zc).^2) < r^2);
amp = amp .* (1-inside); 

%  3 mm cyst
r=3/2/1000;      %  Radius of cyst [mm]
zc=40/1000+z_start;  

inside = ( ((x-xc).^2 + (z-zc).^2) < r^2);
amp = amp .* (1-inside); 

%  2 mm cyst
r=2/2/1000;      %  Radius of cyst [mm]
zc=50/1000+z_start;  

inside = ( ((x-xc).^2 + (z-zc).^2) < r^2);
amp = amp .* (1-inside); 

%  Make the high scattering region and set the amplitudes to 10 times inside

%  6 mm region
r=5/2/1000;       %  Radius of cyst [mm]
xc=-5/1000;     %  Place of cyst [mm]
zc=50/1000+z_start;  

inside = ( ((x-xc).^2 + (z-zc).^2) < r^2) ;
amp = amp .* (1-inside) + 10*amp .* inside; 

%  5 mm region
r=4/2/1000;       %  Radius of cyst [mm]
zc=40/1000+z_start;  

inside = ( ((x-xc).^2 + (z-zc).^2) < r^2) ;
amp = amp .* (1-inside) + 10*amp .* inside; 

%  4 mm region
r=3/2/1000;       %  Radius of cyst [mm]
zc=30/1000+z_start;  

inside = ( ((x-xc).^2 + (z-zc).^2) < r^2) ;
amp = amp .* (1-inside) + 10*amp .* inside; 

%  3 mm region
r=2/2/1000;       %  Radius of cyst [mm]
zc=20/1000+z_start;  

inside = ( ((x-xc).^2 + (z-zc).^2) < r^2) ;
amp = amp .* (1-inside) + 10*amp .* inside; 

%  2 mm region
r=1/2/1000;       %  Radius of cyst [mm]
zc=10/1000+z_start;  

inside = ( ((x-xc).^2 + (z-zc).^2) < r^2) ;
amp = amp .* (1-inside) + 10*amp .* inside; 

%  Place the point scatterers in the phantom

for i=N-5:N
  x(i) = -15/1000;
  y(i) = 0;
  z(i) = z_start + (10+5*10)/1000 + (i-N)*10/1000;
  amp(i) = 20;
  end
  
%  Return the variables

positions=[x y z];
