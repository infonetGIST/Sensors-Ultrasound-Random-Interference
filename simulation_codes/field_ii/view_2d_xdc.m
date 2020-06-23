%  Show a two-dimensional view of the aperture
%
%  Calling view_2d_xdc(Th);
%
%  Argument: Th - Transducer handle
%
%  Return:   Plot of the transducer surface on the current figure
%            in two different views.
%
%  Note uses show_xdc for the display
%
%  Version 1.0, June 23, 1998 by JAJ

function res = view_2d_xdc(Th)

%  Show the geometry

clf
subplot(211)
show_xdc(Th)
view([0 90])
subplot(212)
show_xdc(Th)