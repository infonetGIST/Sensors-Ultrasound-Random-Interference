%  Calculate the intensity profile along the acoustical axis for
%  the transducer defined by the handle Th and plot the
%  resulting pressure and intensity.
% 
%  Version 1.0, 23/6-1998, JAJ 
 
fetal=1;                 %  Whether to use cardiac (0) or fetal (1) intensities
 
%  Set values for the intensity 

if (fetal==1)

  %  For fetal 
  
  f0=5e6;                  %  Transducer center frequency [Hz] 
  M=2;                     %  Number of cycles in pulse 
  Ispta=0.170*100^2;       %  Fetal intensity: Ispta [w/m^2] 
  %Ispta=0.046*100^2;      %  Fetal intensity In Situ: Ispta [w/m^2] 
  Itype='Fetal';           %  Intensity type used 
else
 
 %  For cardiac 
 
  f0=3e6;                  %  Transducer center frequency [Hz] 
  M=8;                     %  Number of cycles in pulse 
  Ispta=0.730*100^2;       %  Cardiac intensity: Ispta [w/m^2] 
  Itype='Cardiac';         %  Intensity type used 
  end

%  Set physical parameters
  
Z=1.480e6;          %  Characteristic acoustic impedance [kg/(m^2 s)] 
Tprf=1/5e3;         %  Pulse repetition frequency [s] 
Tp=M/f0;            %  Pulse duration [s] 
 
P0=sqrt(Ispta*2*Z*Tprf/Tp);   %  Calculate the peak pressure 
 
%  Set the attenuation to 5*0.5 dB/cm, 0.5 dB/[MHz cm] around 
%  f0 and use this: 
 
set_field ('att',2.5*100); 
set_field ('Freq_att',0.5*100/1e6); 
set_field ('att_f0',f0); 
set_field ('use_att',0);          %  Set this flag to one when including attenuation
  
%  Find the scaling factor from the peak value 
 
point=[0 0 0]/1000; 
zvalues=(5:4:200)/1000; 
index=1; 
I=0; 
for z=zvalues 
  point(3)=z; 
  [y,t] = calc_hp(Th,point); 
  I(index)=sum(y.*y)/(2*Z)/fs/Tprf; 
  index=index+1; 
  end 
I_factor=Ispta/max(I); 

%  Find the correct scale factor 
%  This could also be multiplied onto either the
%  transducers excitation or impulse response
 
scale_factor=sqrt(I_factor); 
 
%  Make the calculation in elevation 
 
point=[0 0 0]/1000; 
zvalues=(5:2:200)/1000; 
index=1; 
I=0; 
Ppeak=0; 
for z=zvalues 
  point(3)=z; 
  [y,t] = calc_hp(Th,point);
  y=y*scale_factor; 
  I(index)=sum(y.*y)/(2*Z)/fs/Tprf; 
  Ppeak(index)=max(y); 
  index=index+1; 
  end 
Pmean=sqrt(I*2*Z*Tprf/Tp); 
 
%  Plot the calculated response 
 
figure(1)
subplot(211) 
plot(zvalues*1000,I*1000/(100^2)) 
xlabel('Axial distance [mm]') 
ylabel('Intensity: Ispta  [mW/cm^2]') 
axis([0 max(zvalues*1000) 0 1.1*max(I*1000/(100^2))])
subplot(212) 
plot(zvalues*1000,Ppeak/1e6) 
xlabel('Axial distance [mm]') 
ylabel('Peak pressure [MPa]') 
axis([0 max(zvalues*1000) 0 1.1*max(Ppeak/1e6)])
  
 