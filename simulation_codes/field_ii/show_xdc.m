%  Show the transducer surface in a surface plot
%
%  Calling: show_xdc(Th)
%
%  Argument: Th - Transducer handle
%
%  Return:   Plot of the transducer surface on the current figure
%
%  Note this version onlys shows the defined rectangles
%
%  Version 1.2, August 4, 1999, JAJ

function res = show_xdc (Th)

%  Do it for the rectangular elements

colormap(cool(128));
data = xdc_get(Th,'rect');
[N,M]=size(data);

%  Do the actual display

for i=1:M
  x=[data(11,i), data(20,i); data(14,i), data(17,i)]*1000;
  y=[data(12,i), data(21,i); data(15,i), data(18,i)]*1000;
  z=[data(13,i), data(22,i); data(16,i), data(19,i)]*1000;
  c=data(5,i)*ones(2,2);

  surf(x,y,z,c)
  hold on
  end

%  Put som axis legends on

Hc = colorbar;
view(3)
xlabel('x [mm]')
ylabel('y [mm]')
zlabel('z [mm]')
grid
axis('image')
hold off
