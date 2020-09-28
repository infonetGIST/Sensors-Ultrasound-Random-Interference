% clear all
addpath(genpath('field_ii')) % add path to field ii
field_init(0) % initialize field ii

% synthetic phantom
load _phantom_1010_3555_res_0.25mm.mat

f0=3e6;                %  Transducer center frequency [Hz]
fs=40e6;                %  Sampling frequency [Hz]
c=1540;                  %  Speed of sound [m/s]
lambda=c/f0; % Wavelength [m]
height=4.5/1000; % Height of element [m]
width=0.27/1000; % Width of element [m]
kerf=0.03/1000; % Distance between transducer elements [m]
focus=[0 0 45]/1000;     %  Fixed focal point [m]
N_elements=128;          %  Number of physical elements
N_active=64;             %  Number of active elements

no_lines=50;              %  Number of lines in image
image_width=20/1000;      %  Size of image sector
d_x=image_width/no_lines; %  Increment for image

%  Set the sampling frequency
set_sampling(fs);

folder_name = '_rf_data_conv';

mkdir(folder_name)
mkdir(folder_name,'/img')

%  Generate aperture for emission
xmit_aperture = xdc_linear_array (N_elements, width, height, kerf, 1, 10,focus);

%  Set the impulse response and excitation of the xmit aperture
impulse_response=sin(2*pi*f0*(0:1/fs:2/f0));
impulse_response=impulse_response.*hanning(max(size(impulse_response)))';
xdc_impulse (xmit_aperture, impulse_response);
% xdc_impulse (receive_aperture, impulse_response);

excitation=sin(2*pi*f0*(0:1/fs:2/f0));
xdc_excitation (xmit_aperture, excitation);

%  Generate aperture for reception
receive_aperture = xdc_linear_array (N_elements, width, height, kerf, 1, 10,focus);

%  Set the impulse response for the receive aperture
xdc_impulse (receive_aperture, impulse_response);

focal_zones=[30:20:200]'/1000;
Nf=max(size(focal_zones));
focus_times=(focal_zones-10/1000)/1540;
z_focus=45/1000;          %  Transmit focus

%  Set the apodization
apo=hanning(N_active)';

%% Do conventional B-mode imaging for each synthetic phantom in test_amps

b_mode_test = [];

for i_test = 1 %:size(test_amps,2)
    phantom_amps = test_amps(:,i_test);
   
    % Do linear array imaging
    % Do imaging line by line
    for i=[1:no_lines]

        file_name=[folder_name,'/rf_ln',num2str(i),'.mat'];

        %  Save a file to reserve the calculation
        cmd=['save ',folder_name,'/rf_ln',num2str(i),'.mat i'];
        eval(cmd);

        disp(['Now making line ',num2str(i)])

        %  The the imaging direction
        x= -image_width/2 +(i-1)*d_x;

        %   Set the focus for this direction with the proper reference point
        xdc_center_focus (xmit_aperture, [x 0 0]);
        xdc_focus (xmit_aperture, 0, [x 0 z_focus]);
        xdc_center_focus (receive_aperture, [x 0 0]);
        xdc_focus (receive_aperture, focus_times, [x*ones(Nf,1), zeros(Nf,1), focal_zones]);

        % xdc_focus_times()
        %  Calculate the apodization 
        N_pre  = round(x/(width+kerf) + N_elements/2 - N_active/2)
        N_post = N_elements - N_pre - N_active
        apo_vector=[zeros(1,N_pre) apo zeros(1,N_post)];
        xdc_apodization (xmit_aperture, 0, apo_vector);
        xdc_apodization (receive_aperture, 0, apo_vector);

        %   Calculate the received response
        [rf_data, tstart]=calc_scat(xmit_aperture, receive_aperture, phantom_positions, phantom_amps);

        %  Store the result
        cmd=['save ',folder_name,'/rf_ln',num2str(i),'.mat rf_data tstart'];
        disp(cmd)
        eval(cmd);

    end
    %  Read the data and adjust it in time 

    min_sample=0;
    for i=1:no_lines
      %  Load the result
        cmd=['load ',folder_name,'/rf_ln',num2str(i),'.mat'];
        disp(cmd)
        eval(cmd)

      %  Find the envelope
    %     rf_data(0.001 > rf_data & rf_data > -0.001) = 0;
        rf_env=abs(hilbert([zeros(round(tstart*fs-min_sample),1); rf_data]));
        env(1:max(size(rf_env)),i)=rf_env;
    end
    
    D=10;         %  Sampling frequency decimation factor
    dB_range=60;  % Dynamic range for display in dB

    disp('Finding the envelope')
    log_env=env(1:D:max(size(env)),:)/max(max(env));
    log_env=20*log10(log_env);
    log_env=127/dB_range*(log_env+dB_range);

    %  Make an interpolated image
    disp('Doing interpolation')
    ID=20;
    [n,m]=size(log_env);
    new_env=zeros(n,m*ID);
    for i=1:n
      new_env(i,:)=interp(log_env(i,:),ID);
    end
    [n,m]=size(new_env);

    fn=fs/D;
    clf

    cmd = ['save ',folder_name,'/img/b_mode_test_amp_',num2str(i_test),'.mat new_env i_test ID no_lines d_x n fn min_sample fs'];
    eval(cmd)
    
    b_mode_test(:,:,i_test) = new_env;
    
end

cmd = ['save ',folder_name,'/img/b_mode_test_amps_all_.mat b_mode_test i_test ID no_lines d_x n fn min_sample fs'];
eval(cmd)

image(((1:(ID*no_lines-1))*d_x/ID-no_lines*d_x/2)*1000,((1:n)/fn+min_sample/fs)*1540/2*1000,new_env)
xlabel('Lateral distance [mm]')
ylabel('Axial distance [mm]')
colormap(gray(128))
axis('image')
title(['B mode test'])
axis(region_of_interest)
axisLimits = axis; % get the current limits
set(gca,'XTickMode','manual'); 
%we will have 3 ticks on X label
set(gca,'XTick',[axisLimits(1):5:axisLimits(2)]);
set(gca,'XTickLabel',[axisLimits(1):5:axisLimits(2)]);
set(gca,'YTickMode','manual');
%we will have 3 ticks on X label
set(gca,'YTick',[axisLimits(3):5:axisLimits(4)]);
set(gca,'YTickLabel',[axisLimits(3):5:axisLimits(4)]);

