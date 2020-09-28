
clear all
close all

region_of_interest = [-10 10 35 55]; % we recommend to keep aspect ratio 1:1 
resolution = 0.25; % resolution defines how many points will be in the final phantom

%file name

file_name = ['_phantom_',regexprep(num2str(region_of_interest(1:2)),'[^\w'']',''),'_',regexprep(num2str(region_of_interest(3:4)),'[^\w'']',''),'_res_',num2str(resolution),'mm'];


points_x  = region_of_interest(1):resolution:region_of_interest(2);
points_z = region_of_interest(3):resolution:region_of_interest(4);

dif_ = length(points_z) - length(points_x);

num_points = length(points_x)*length(points_z); %total number of points

%% phantom coordinates (x y z)
scan_points = [];

for t = 1:length(points_z)
    for r = 1:length(points_x)
        scan_points = [scan_points; ([points_x(r) 0 points_z(t)])];

    end
        
end

phantom_positions = scan_points/1000; % convert coordinates to mm
phantom_amplitudes = zeros(1,size(scan_points,1))';
all_point_idx = 1:1:num_points;

draw_mat = [];
for t = 1:1:length(points_x)
    draw_mat = [draw_mat all_point_idx(((t-1)*length(points_z))+1:t*length(points_z))'];
    
end

test_num = 2;
test_amps = [];

% create amplitudes
for k = 1:test_num
	if k == 1
        amps = reshape(phantom('Modified Shepp-Logan',length(points_x))', [length(points_x)*length(points_z),1]);
    elseif k == 2
        amps = reshape(phantom('Modified Shepp-Logan',length(points_x))', [length(points_x)*length(points_z),1]);

    end

    test_amps = [test_amps amps];
    uy = reshape(test_amps(:,k), [length(points_z),length(points_x)]);
%     imwrite(uy,['data\NN0812\train\x\image_',num2str(k),'.png'])

end

cmd2 = ['save ',file_name,'.mat phantom_positions phantom_amplitudes test_amps region_of_interest points_x points_z resolution num_points test_num'];
eval(cmd2)

