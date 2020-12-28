% add path to field ii simulation software
addpath('field_ii')
% initialize field ii
field_init

% set parameters of simulation
f0=3e6; % Transducer center frequency [Hz]
fs=40e6; % Sampling frequency [Hz]
c=1540; % Speed of sound [m/s]
lambda=c/f0; % Wavelength [m]
height=4.5/1000; % Height of element [m]
width=0.27/1000; % Width of element [m]
kerf=0.03/1000; % Distance between transducer elements [m]

% Define the transducer aperture
Tx_elements=128; % Number of elements
Rx_elements = 128;
focus=[0 0 45]/1000; % Initial electronic focus
Tx = xdc_linear_array (Tx_elements, width, height, kerf, 2, 3, focus); % Tx array
Rx = xdc_linear_array (Tx_elements, width, height, kerf, 2, 3, focus); % Rx array

% load random excitation signals
load rand_seq_128_15_2.mat % load excitation sequences
% conv_excitation=sin(2*pi*f0*(0:1/fs:2/f0));
% figure;hold on;plot(excitation_signals(m,:));plot(conv_excitation)

% assign excitation signals to array elements
for m = 1:Tx_elements
    ele_waveform(Tx, m, excitation_signals(m,:));
end

% define ROI and resolution delta
region_of_interest = [-10 10 35 55];
res = 0.25;
% generate general scatterers
points_x  = region_of_interest(1):res:region_of_interest(2);
points_z = region_of_interest(3):res:region_of_interest(4);
dif_ = length(points_z) - length(points_x);
num_points = length(points_x)*length(points_z);

% phantom points
scan_points = [];
for t = 1:length(points_z)
    for r = 1:length(points_x)
        scan_points = [scan_points; ([points_x(r) 0 points_z(t)])];
    end
end

%% perform simulation
% the for loop is used to simulate 3 pulse-echo cycles.
% at each cycle we use a group of scatterers at corresponding 40, 45, and 50 mm depth
% 
for i_ = 1:2
    
    phantom_positions = scan_points/1000;
    phantom_amplitudes = zeros(1,size(scan_points,1))';

    switch(i_)
        case 1
            phantom_amplitudes(1641) = 1;
            phantom_amplitudes(1657) = 1;
            phantom_amplitudes(1665) = 1;
            phantom_amplitudes(1681) = 1;
            
            uy = reshape(phantom_amplitudes, [length(points_z),length(points_x)]);
            imwrite(uy',['pictures/step_0_image_',num2str(i_),'.png'])
    
            disp('case 1')
            subfigure_letter = 'a';
            
            %% calcultate echo signals
            [v1,t]=calc_scat_multi (Tx, Rx, phantom_positions, phantom_amplitudes);

            [N,M]=size(v1);
            v1=v1/max(max(v1));
            % plot the image
            colormap(gray(128))
            subplot(1,3,i_);
            imagesc(v1)
            
            set(gca,'xtick',[])
            set(gca,'ytick',[])

            axisLimits = axis; % get the current limits
            set(gca,'XTickMode','manual');
            set(gca,'XTick',[1 32 64 96 128]);
            set(gca,'XTickLabel',[region_of_interest(1):5:region_of_interest(2)]);
            set(gca,'YTickMode','manual');
            set(gca,'YTick',[round(axisLimits(3)):1000:round(axisLimits(4))]-1);
            set(gca,'YTickLabel',[region_of_interest(3)+5:5:region_of_interest(4)]);

            xlabel({'Lateral distance [mm]';['\fontsize{12}\fontname{Times New Roman}(',subfigure_letter,')']})
            ylabel('Axial distance [mm]')            

        case 2
            phantom_amplitudes(1642) = 1;
            phantom_amplitudes(1657) = 1;
            phantom_amplitudes(1665) = 1;
            phantom_amplitudes(1681) = 1;
            
            uy = reshape(phantom_amplitudes, [length(points_z),length(points_x)]);
            imwrite(uy',['pictures/step_0_image_',num2str(i_),'.png'])

            disp('case 2')
            subfigure_letter = 'b';

            [v2,t]=calc_scat_multi (Tx, Rx, phantom_positions, phantom_amplitudes);

            [N,M]=size(v2);
            v2=v2/max(max(v2));
            % plot the image
            colormap(gray(128))
            subplot(1,3,i_);
            imagesc(v2)
            
            set(gca,'xtick',[])
            set(gca,'ytick',[])

            axisLimits = axis; % get the current limits
            set(gca,'XTickMode','manual');
            set(gca,'XTick',[1 32 64 96 128]);
            set(gca,'XTickLabel',[region_of_interest(1):5:region_of_interest(2)]);
            set(gca,'YTickMode','manual');
            set(gca,'YTick',[round(axisLimits(3)):1000:round(axisLimits(4))]-1);
            set(gca,'YTickLabel',[region_of_interest(3)+5:5:region_of_interest(4)]);

            xlabel({'Lateral distance [mm]';['\fontsize{12}\fontname{Times New Roman}(',subfigure_letter,')']})
            ylabel('Axial distance [mm]')            
    end    

end

corr2(v1(:,64),v2(:,64))

subfigure_letter = 'c';

v_abs_diff = imabsdiff(v1,v2);
subplot(1,3,3);
imagesc(v_abs_diff)

axisLimits = axis; % get the current limits
set(gca,'XTickMode','manual');
set(gca,'XTick',[1 32 64 96 128]);
set(gca,'XTickLabel',[region_of_interest(1):5:region_of_interest(2)]);
set(gca,'YTickMode','manual');
set(gca,'YTick',[round(axisLimits(3)):1000:round(axisLimits(4))]-1);
set(gca,'YTickLabel',[region_of_interest(3)+5:5:region_of_interest(4)]);

xlabel({'Lateral distance [mm]';['\fontsize{12}\fontname{Times New Roman}(',subfigure_letter,')']})
ylabel('Axial distance [mm]') 

