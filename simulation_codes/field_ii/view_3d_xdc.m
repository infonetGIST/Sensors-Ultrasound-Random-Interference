%  Show a three-dimensional view of the aperture
%
%  Calling view_3d_xdc(Th);
%
%  Argument: Th - Transducer handle
%
%  Return:   Plot of the transducer surface on the current figure
%            in three different views.
%
%  Note uses show_xdc for the display
%
%  Version 1.0, June 23, 1998 by JAJ

function res = view_3d_xdc(Th)

%  Show the geometry

clf
subplot(221)
show_xdc(Th)
view([90 0])
subplot(222)
show_xdc(Th)
view([0 90])
subplot(223)
show_xdc(Th)
view([0 0])
subplot(224)
show_xdc(Th)
