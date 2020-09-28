%
clear all
addpath('field_ii')
field_init(0);

load _phantom_1010_3555_res_1mm.mat

folder_name ='_rf_data_spatial_impulse_responses';
mkdir(folder_name)

folder_im = [folder_name,'\','_im'];
mkdir(folder_im);

folder_tests = [folder_name,'\','_tests'];
mkdir(folder_tests);


Rmax = 50/1000; % Maximum range
Rmin = 0/1000; % Minimum range
if (Rmin < 0) Rmin = 0; end;
Tmin = 2*Rmin / c; % Minumum time
Tmax = 2*Rmax / c; % Maximum time
Smin = round(Tmin * fs); % Minimum samples
Smax = round(Tmax * fs); % Maximum samples
Stotal = (Smax - Smin); % Total number of samples

%%
number_of_elements = 128;
binary_seq_length = 13;

half_sine_chirp = sin(pi/2*f0*(0:1/fs:2/f0));

excitation_signals = [];
temp_array = round(rand(number_of_elements,binary_seq_length));
temp_array(~temp_array) = -1;

size_m = size(temp_array);

excitation_signals = [];

for m = 1:size_m(1)
    mt = temp_array(m,:);
    mv = [];
    ms = [];

    for k = 1:length(mt)
        mv = half_sine_chirp * mt(k);
        ms = [ms mv];
    end

    ms = [ms 0];
    excitation_signals(m,:) = ms;

end
%%

% Define the transducer
Tx = xdc_linear_array (Tx_elements, width, height, kerf, 1, 1, focus);

impulse_response=sin(2*pi*f0*(0:1/fs:2/f0));
impulse_response=impulse_response.*hanning(max(size(impulse_response)))';
xdc_impulse (Tx, impulse_response);

% Set the impulse response and excitation of the emit aperture

for m = 1:Tx_elements
    ele_waveform(Tx, m, excitation_signals(m,:));
end

file_name_m_full=['save ',folder_im,'\_excitation_signals.mat excitation_signals'];
eval(file_name_m_full)

amps = phantom_amplitudes;
ss = size(phantom_positions,1);
min_sample = 0;

for k = 1:ss  

    file_name_save=['save ',folder_im,'\rf_im_point_',num2str(k),'.mat k'];
    eval(file_name_save);

    % Do the calculation
    amps = zeros(size(phantom_positions,1),1);
    amps(k) = 1;

    [v,t]=calc_scat_multi (Tx, Tx, phantom_positions, amps);

    %%
    cmd1 =['save ',folder_im,'\rf_im_point_',num2str(k),'.mat v t phantom_positions amps'];
    eval(cmd1)
    disp(['Now scanning point ',num2str(k),' out of ',num2str(ss)])
    clear v t amps

end

test_num = size(test_amps,2);


cmd2 = ['save ',folder_im,'\_setup.mat f0 fs c lambda height width kerf  Tx_elements focus excitation_signals phantom_positions test_num test_amps region_of_interest points_x points_z res num_points folder_name'];
eval(cmd2)



for q = 1 : test_num

    file_name_t_save=['save ',folder_tests,'\rf_test_',num2str(q),'.mat q'];
    eval(file_name_t_save);
    % Do the calculation

    amps = test_amps(:,q);

    [v,t]=calc_scat_multi (Tx, Tx, phantom_positions, amps);

    cmd1 =['save ',folder_tests,'\rf_test_',num2str(q),'.mat v t phantom_positions amps']; 
    eval(cmd1)
    disp(['Now scanning test points ',num2str(q),' out of ',num2str(test_num)])
    clear v t amps
    
end






