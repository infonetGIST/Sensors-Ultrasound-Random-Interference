% by NP 2019/12/13

N = 50; % image size N by N
samples = N*N/2; % # of samples of the measurement signal

f_image = phantom('Modified Shepp-Logan',N); % generate shep-logan phantom image
f_image = (eye(N,N)*-1)+f_image; % multiple by random real numbers

figure('Units', 'Pixels','Position', [100,100,1500, 500]);
subplot(1,3,1) % show the phantom image
imagesc((f_image))
title('image f')

f = reshape(f_image,N*N,1); % vectorize the image f

image_comp = [];
G_tall = [];
p_tall = [];

for i = 1:128 % number of iterations

    G = randn(samples,N*N); % create transmission matrix
    p = G*f; % take measurements of the image f
    
    %%
    p_noise = awgn(p,10,0); % add noise
    
%     G_tall = [G_tall; G];
%     p_tall = [p_tall; p_noise];
    
%     f_hat = lsqnonneg(G,p_noise); % least-squares problems - nonnegative
    f_hat = lsqlin(G,p_noise); % reconstruct using least-squares problems
    
    image_comp = [image_comp f_hat]; % save the results
    
end

image_comp_ = abs(sum(image_comp,2)); % make compound
f_image_hat = reshape(image_comp_,N,N); % reshape compounded image

subplot(1,3,2) % show the recovered image
imagesc((f_image_hat))
title('image f hat')

%%

%% tall

% f_hat_tall = lsqnonneg(G_tall,p_tall); % least-squares problems - nonnegative
suf_hat_tall = lsqlin(G_tall,p_tall); % reconstruct using least-squares problems
    
f_image_hat_tall = reshape(f_hat_tall,N,N);


subplot(1,3,3) % show the recovered image
imagesc((f_image_hat_tall))
title('image f hat tall')


