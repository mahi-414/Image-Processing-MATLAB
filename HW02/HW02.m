%% Question 1

% loading images
edges = load("Edges.mat").Edges;
edges_g = load("Edges_gnoise.mat").Edges_gnoise;
edges_sp = load("Edges_spnoise.mat").Edges_spnoise;

% creating filters
avg3 = ones(3)/9;
avg9 = ones(9)/81;

% creating filtered images from gaussian noise
eg_avg3 = imfilter(edges_g,avg3);
eg_avg9 = imfilter(edges_g,avg9);
eg_med = medfilt2(edges_g);
eg_w = wiener2(edges_g, [3 3], 0.005);


% plotting filtered gaussian noise images
figure
subplot(2,3,1)
imshow(edges_g)
title("edges (gaussian noise)")
subplot(2,3,2)
imshow(eg_avg3)
title("3x3 averaging filter")
subplot(2,3,3)
imshow(eg_avg9)
title("3x3 averaging filter")
subplot(2,3,4)
imshow(eg_med)
title("median filter")
subplot(2,3,5)
imshow(eg_w)
title("wiener filter")

% filtering salt and pepper images
esp_avg3 = imfilter(edges_sp,avg3);
esp_avg9 = imfilter(edges_sp,avg9);
esp_med = medfilt2(edges_sp);
esp_w = wiener2(edges_sp, [3 3], 0.03);

% plotting filtered salt and pepper images
figure
subplot(2,3,1)
imshow(edges_sp)
title("edges (salt and pepper)")
subplot(2,3,2)
imshow(esp_avg3)
title("3x3 averaging filter")
subplot(2,3,3)
imshow(esp_avg9)
title("9x9 averaging filter")
subplot(2,3,4)
imshow(esp_med)
title("median filter")
subplot(2,3,5)
imshow(esp_w)
title("wiener filter")

%% Question 2

gauss_img = abs(50 + randn(500)*30); % creating image with gaussian noise
avg5 = ones(5)/25; % creating 5x5 avg filter

gauss_img_mean = mean2(gauss_img) % mean of original image
gauss_img_stdev = std2(gauss_img) % standard deviation of original image

gfilt_avg = imfilter(gauss_img, avg5); % original image through 5x5 kernel
gauss_img_filt1_stdev = std2(gfilt_avg) % sd of filtered image
expected_filtered_stdev = gauss_img_stdev/5 % expected sd of filtered image
gfilt_avg2 = imfilter(gfilt_avg, avg5); % filtered image through 5x5 kernel
gauss_img_filt2_stdev = std2(gfilt_avg2) % sd of new filtered image
gfilt_med = medfilt2(gauss_img, [5 5]); % original image through median filter
gauss_img_medfilt_stdev = std2(gfilt_med) % sd of median filtered image

% histogram of original image and filtered through 5x5 kernel
figure
subplot(1,2,1)
histogram(gauss_img)
title("original image")
subplot(1,2,2)
histogram(gfilt_avg)
title("5x5 averaging filter")

% displaying images
figure
subplot(2,2,1)
imshow(gauss_img, [])
title("original gaussian image")
subplot(2,2,2)
imshow(gfilt_avg, [])
title("gaussian image filtered through 5x5 kernel")
subplot(2,2,3)
imshow(gfilt_avg2, [])
title("gaussian image filtered through 5x5 kernel twice")
subplot(2,2,4)
imshow(gfilt_med, [])
title("gaussian image with median filter applied")

% converting to 8-bit data
gauss_img_uint8 = uint8(gauss_img);
gauss_filt_uint8 = uint8(gfilt_avg);
% finding bounds of original and 8-bit data
[min_gauss_orig, max_gauss_orig] = bounds(gauss_img, "all") % bounds of original image
[min_gfilt, maxgfilt] = bounds(gfilt_avg, "all") % bounds of filtered image
[min_gauss_orig_uint8, max_gauss_orig_uint8] = bounds(gauss_img_uint8, "all") % bounds of original image (8-bit)
[min_gfilt_uint8, max_filt_uint8] = bounds(gauss_filt_uint8, "all") % bounds of filtered image (8-bit)

% displaying 8-bit data
figure
subplot(1,2,1)
imshow(gauss_img_uint8)
title("original image 8-bit")
subplot(1,2,2)
imshow(gauss_filt_uint8)
title("averaging filter applied 8-bit")

%% Question 3


% load image
edges_sp = load("Edges_spnoise.mat").Edges_spnoise;

% create median filter in shape of cross
cross = [0 0 1 0 0; 0 0 1 0 0; 1 1 1 1 1; 0 0 1 0 0; 0 0 1 0 0];

% median filtered image (cross shape)
edges_med_cross = ordfilt2(edges_sp,5,cross);
% median filtered image (medfilt)
edges_sp_med = medfilt2(edges_sp); % 

sd_edges = std2(edges_sp) % sd of original image
sd_medcross_edges = std2(edges_med_cross) % sd of cross filtered image
sd_medfilt_edges = std2(edges_sp_med) % sd of medfilt2 image

% displaying images
figure
subplot(1,3,1)
imshow(edges_sp, [])
title("original image")
subplot(1,3,2)
imshow(edges_med_cross, [])
title("median filter (cross)")
subplot(1,3,3)
imshow(edges_sp_med, [])
title("MATLAB median filter")

%% Question 4

% load images
mri_noisy = imread("mri_brain_sagittal-noisy.tif");
mri_clean = imread("mri_brain_sagittal.tif");

avg3 = ones(3)/9; % creating averaging kernel
mri_avg3 = imfilter(mri_noisy,avg3); % image with averaging filter

% anisotropic diffusion filtered image
mri_diffuse = imdiffusefilt(mri_noisy,"NumberOfIterations",2, ...
    "Connectivity", "minimal", "GradientThreshold", [1000 1000]);

% testing params
% figure
% subplot(1,3,1)
% imshow(mri_clean, [])
% clim([50 300])
% subplot(1,3,2)
% imshow(imdiffusefilt(mri_noisy, "NumberOfIterations",3, ...
%     "Connectivity", "minimal", "GradientThreshold", gradThresh), [])
% subplot(1,3,3)
% imshow(imdiffusefilt(mri_noisy, "NumberOfIterations",3, ...
%     "Connectivity", "minimal", ...
%     "GradientThreshold", uint16([500 500 500]), ...
%     "ConductionMethod","exponential"), [])

% plot images
figure
subplot(2,2,1)
imshow(mri_clean, [])
clim([50 300])
title("original clean image")
subplot(2,2,2)
imshow(mri_noisy, [])
clim([0 300])
title("noisy image")
subplot(2,2,3)
imshow(mri_avg3, [])
clim([20 283])
title("3x3 averaging filter")
subplot(2,2,4)
imshow(mri_diffuse, [])
clim([40 260])
title("anistropic diffusion filter")

        
        



