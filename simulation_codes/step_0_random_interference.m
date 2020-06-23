addpath('field_ii')

field_init

f0=3e6; % Transducer center frequency [Hz]
fs=40e6; % Sampling frequency [Hz]
c=1540; % Speed of sound [m/s]
lambda=c/f0; % Wavelength [m]
height=4.5/1000; % Height of element [m]
width=0.27/1000; % Width of element [m]
kerf=0.03/1000; % Distance between transducer elements [m]

(width+kerf)*128

Tx_elements=128; % Number of elements
Rx_elements = 128;
focus=[0 0 45]/1000; % Initial electronic focus
% Define the transducer
load rand_seq_128_15_2.mat % load excitation sequences

Tx = xdc_linear_array (Tx_elements, width, height, kerf, 2, 3, focus);
Rx = xdc_linear_array (Tx_elements, width, height, kerf, 2, 3, focus);
% Set the impulse response and excitation of the emit aperture

% ele_ = 1;
% 
% for m = 1:Tx_elements
%     if rem(m, ele_) ~= 0
%         m_full(m,:) = m_full(m,:).*0;
%     end
% end

for m = 1:Tx_elements
    ele_waveform(Tx, m, excitation_signals(m,:));
end

%%
region_of_interest = [-10 10 35 55];
res = 0.25;

points_x  = region_of_interest(1):res:region_of_interest(2);
points_z = region_of_interest(3):res:region_of_interest(4);

dif_ = length(points_z) - length(points_x);

num_points = length(points_x)*length(points_z);

%% target phantom coor
scan_points = [];

for t = 1:length(points_z)
    for r = 1:length(points_x)
        scan_points = [scan_points; ([points_x(r) 0 points_z(t)])];

    end
        
end


for i_ = 1:3
    
    phantom_positions = scan_points/1000;
    phantom_amplitudes = zeros(1,size(scan_points,1))';

    
    switch(i_)
        case 1
            phantom_amplitudes(1641) = 1;
            phantom_amplitudes(1657) = 1;
            phantom_amplitudes(1665) = 1;
            phantom_amplitudes(1681) = 1;
            disp('case 1')
            
            subfigure_letter = 'a';
        case 2
            phantom_amplitudes(3261) = 1;
            phantom_amplitudes(3277) = 1;
            phantom_amplitudes(3285) = 1;
            phantom_amplitudes(3301) = 1;
            disp('case 2')
            subfigure_letter = 'b';
        case 3
            phantom_amplitudes(4881) = 1;
            phantom_amplitudes(4897) = 1;
            phantom_amplitudes(4905) = 1;
            phantom_amplitudes(4921) = 1;
            disp('case 3')
            subfigure_letter = 'c';
          
    end    
%%
    %%
    % Define the transducer
    % Set the impulse response and excitation of the emit aperture
    % Do the calculation
    [v,t]=calc_scat_multi (Tx, Rx, phantom_positions, phantom_amplitudes);
    % 

    [N,M]=size(v);
    v=v/max(max(v));

    colormap(gray(128))
    subplot(1,3,i_);
    imagesc(v)

    set(gca,'xtick',[])
    set(gca,'ytick',[])
    
    axisLimits = axis; % get the current limits
    set(gca,'XTickMode','manual');
    %we will have 3 ticks on X label
    set(gca,'XTick',[1 32 64 96 128]);
    set(gca,'XTickLabel',[region_of_interest(1):5:region_of_interest(2)]);
    set(gca,'YTickMode','manual');
    %we will have 3 ticks on X label
    set(gca,'YTick',[round(axisLimits(3)):1000:round(axisLimits(4))]-1);
    set(gca,'YTickLabel',[region_of_interest(3)+5:5:region_of_interest(4)]);
    
    xlabel({'Lateral distance [mm]';['\fontsize{10}\fontname{Times New Roman}(',subfigure_letter,')']})
    ylabel('Axial distance [mm]')
end


% figure
% % Plot the individual responses
% subplot(211)
% [N,M]=size(v);
% v=v/max(max(v));
% for i=1:Tx_elements
%     plot((0:N-1)/fs+t,v(:,i)+i), hold on
% end
% hold off
% title('Individual traces')
% xlabel('Time [s]')
% ylabel('Normalized response')
% subplot(212)
% plot((0:N-1)/fs+t,sum(v'))
% title('Summed response')
% xlabel('Time [s]')
% ylabel('Normalized response')

