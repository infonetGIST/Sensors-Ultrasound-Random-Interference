%  
% CS load data in to matrix
%
clear all
close all


addpath(genpath('cs_alg\YALL1-v1.4'))


%% Choose targets GUI

% f = figure('Position', [500, 500, 500, 250]);
% set(gcf,'Color', 'white')
% text(0.1,0.5,'Choose which problem to solve:','fontsize',18,'color','b')
% set(gca,'Color','white');
% set(gca,'XColor','white');
% set(gca,'YColor','white');
% 
% btn = uicontrol('Style', 'pushbutton', 'String', 'Two points',...
%     'Position', [120 60 100 30],'Callback', 't_num=32;uiresume(gcbf)');  
% btn = uicontrol('Style', 'pushbutton', 'String', 'Random scatterers',...
%     'Position', [230 60 100 30],'Callback', 't_num=randi(30,1);uiresume(gcbf)');  
% uiwait(gcf); 
% disp('Loading data, Doing CS recovery, Wait few seconds');

% close(f);

[fname pname] = uigetfile('*.mat','Choose phantom .mat file');
load ([pname fname])
% load (['E:\Ultrasound_simulations\field_\cosmos\PAPER DATA EXP\RAND\20181008-145555\4_idx4_layer0_BDATA_RF.mat'])
% % load ([pname 'bmode\b_mode_test_v20170301_s_1010-3555-res0.25.mat'])
% AdcData_frame = [AdcData_frame000(:,:,1); AdcData_frame000(:,:,2); AdcData_frame000(:,:,3); AdcData_frame000(:,:,4)];

%%
% Set initial parameters
f0=3e6; % Transducer center frequency [Hz]
fs=40e6; % Sampling frequency [Hz]
c=1540; % Speed of sound [m/s]
lambda=c/f0; % Wavelength [m]
height=4.5/1000; % Height of element [m]
width=0.27/1000; % Width of element [m]
kerf=0.03/1000; % Distance between transducer elements [m]

Rmax = 60/1000; % Maximum range
Rmin = 0/1000; % Minimum range
if (Rmin < 0) Rmin = 0; end;
Tmin = Rmin / c; % Minumum time
Tmax = Rmax / c; % Maximum time
Smin = 2*round(Tmin * fs); % Minimum samples
Smax = 2*round(Tmax * fs); % Maximum samples
Stotal = (Smax - Smin); % Total number of samples

t_ = 2.216e-05;
%%

% tm_m_ = sort([1:10:128 128:-10:1]);
tm_m_ = [1:1:128];
% tm_m_ = sort([1:10:128 128:-10:1]);
t_num= 122;

image_comp = [];


for tm_m = 1:1:length(tm_m_)
	tm_m
    load ([pname 'cs_tm_ch',num2str(tm_m_(tm_m)),'.mat'])
    load ([pname 'cs_tt_ch',num2str(tm_m_(tm_m)),'.mat'])
    
%%
    load (['field_\20181022_v044_multi\pre_test_ele_1\pre_test_2\cs_tt_ch',num2str(tm_m_(tm_m)),'.mat']);
    tt_ch_v0_ = tt_ch_v0;
    test_amps_ = test_amps;
    load ([pname 'cs_tt_ch',num2str(tm_m_(tm_m)),'.mat']);
    tt_ch_v0 = [tt_ch_v0 tt_ch_v0_(:,121:1:122)];
    test_amps = [test_amps test_amps_];
    disp('Files loaded')

%%
%     y_tt1 = double(AdcData_frame(tm_m,:)');
%    

    y_tt1 = [zeros(round(t_*fs),1); tt_ch_v0(:,t_num)];
%%
    gMatrix1 = [zeros(round(t_*fs),6561); tm_ch_v0()];
    non_zero_m = [];
    for row = 1:size(gMatrix1,1)
        if any(gMatrix1(row,:))
            non_zero_m = [non_zero_m row];
        end
    end

    gMatrix = gMatrix1(non_zero_m(1):1:size(y_tt1,1),:);

    %% Chose TM matrix
    G = gMatrix./max(max(gMatrix));
    % Measurements
    y = y_tt1(non_zero_m(1):1:size(y_tt1,1),:)./max(max(gMatrix));

    %% CS algorithm with parameters

    opts.tol = 1e-3;
    opts.maxit = 9999; % no of iteration
    opts.nonorth = 1;
    opts.nonneg = 1;
    opts.rho = 1e-3;
    % Do CS reconstruction
    
    tic
    [sparse_x, out] = yall1(G, y, opts);
    toc
       
    image_comp = [image_comp sparse_x];


end

% recs = G*sparse_x;

image_comp_norm = image_comp(1:1:max(size(image_comp)),:)/max(max(image_comp));
recovered_image = sum(image_comp_norm,2)/length(tm_m_);
uy = reshape(recovered_image, [length(points_z),length(points_x)]);

figure
imagesc(abs(uy))
colormap(gray(128))

figure
uy_test = reshape(test_amps(:,t_num), [length(points_z),length(points_x)]);
% colormap(gray(256))
imagesc(abs(uy_test))

figure
x_ = G*sparse_x;
plot(y);hold on;plot(x_)

cmd1 = ['save ',pname,'190523_comp_all_angle.mat image_comp recovered_image t_num -v7.3'];
eval(cmd1)
%%

image_comp_ = image_comp;
dB = 60;
min_dB = 10^(-dB/20);
for rt = 1:1:size(image_comp_,2)
    sparse_x_ = image_comp_(:,rt);
    for i=1:6561
        if(sparse_x_(i) < min_dB)
            sparse_x_(i) = 0;
        else
            sparse_x_(i) = 255*((20/dB)*log10(sparse_x_(i))+1);
        end
    end
    image_comp_(:,rt) = sparse_x_;
    
end

image_comp_norm_ = image_comp_(1:1:max(size(image_comp_)),:)/max(max(image_comp_));
recovered_image_ = sum(image_comp_norm_,2)/length(tm_m_);
uy_ = reshape(recovered_image_, [length(points_z),length(points_x)]);

figure
imagesc(abs(uy_))
colormap(gray(128))

