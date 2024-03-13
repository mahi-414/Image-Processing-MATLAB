%% Question 1

flat_test1 = ones(20)*100; % creating flat test image
constant_kernel1 = ones(5).*3; % creating kernel
size(flat_test1)
full_shape1 = conv2(flat_test1, constant_kernel1, "full"); % creating convoluted image with 'full' shape
size(full_shape1) % size of matrix
same_shape1 = conv2(flat_test1, constant_kernel1, "same"); % creating convoluted image with 'same' shape
size(same_shape1) % size of matrix
valid_shape1 = conv2(flat_test1, constant_kernel1, "valid"); % creating convoluted image with 'valid' shape
size(valid_shape1) % size of matrix

figure
subplot(2,2,1)
imshow(flat_test1, [0,255])
title("original")
subplot(2,2,2)
imshow(full_shape1, [])
title("shape=full")
subplot(2,2,3)
imshow(same_shape1, [])
title("shape=same")
subplot(2,2,4)
imshow(valid_shape1, [])
title("shape=valid")

%% Question 2

einstein_blur = im2double(imread("EINSTEIN_8bit-blur.tif"));
einstein_img = im2double(imread("EINSTEIN_8bit.tif"));
gauss_filter = fspecial('gaussian', 13, 7); % creating kernel
einstein_gauss_blur = conv2(einstein_blur, gauss_filter, "same"); % convoluting
einstein_edges = einstein_blur - einstein_gauss_blur; % creating edges
sharpened_einstein = einstein_blur + einstein_edges; % addiing edges
%{
parameters: hsize, sigma
%}

figure
subplot(1,3,1)
imshow(einstein_blur, [])
title("original blurred image")
subplot(1,3,2)
imshow(sharpened_einstein, [])
title("sharpened image")
subplot(1,3,3)
imshow(einstein_img, [])
title("original sharp image")

% figure
% for i=2:17
%     subplot(4,4,i-1)
%     filter_test = fspecial('gaussian', 13, i); % creating kernel
%     img_blurred = conv2(einstein_blur, filter_test, "same"); % convoluting
%     img_edges = einstein_blur - img_blurred; % creating edges
%     img_sharp = einstein_blur + einstein_edges;
%     imshow(img_sharp)
% end

%% Question 3
tumor_img = load("TUMOR.MAT").tumor; % loading tumor image
sobel_filter = fspecial("sobel"); % creating filter
tumor_sobel = imfilter(tumor_img, sobel_filter); % filtering image
tumor_sobel_img = uint8(255 * mat2gray(tumor_sobel)); % modifying image
tumor_threshold = im2bw(tumor_sobel_img,0.55); % thresholding filtered image
figure
subplot(1,3,1)
imshow(tumor_img, [])
title("original tumor image")
subplot(1,3,2)
imshow(tumor_sobel_img)
title("tumor with sobel edge detection")
subplot(1,3,3)
imshow(tumor_threshold)
title("tumor with threshold applied")

%% Question 4

% creating filtered images
edges_img = load("edges.MAT").edges;
sobel_edges = edge(edges_img,"sobel");
prewitt_edges = edge(edges_img, "prewitt");
roberts_edges = edge(edges_img, "roberts");
log_edges = edge(edges_img, "log");
zc_edges = edge(edges_img,"zerocross");
canny_edges = edge(edges_img, "canny");

% displaying filtered images
figure
subplot(2,4,1)
imshow(edges_img, [])
title("original image")
subplot(2,4,2)
imshow(sobel_edges, [])
title("sobel edge detection")
subplot(2,4,3)
imshow(prewitt_edges, [])
title("prewitt edge detection")
subplot(2,4,4)
imshow(roberts_edges, [])
title("roberts edge detection")
subplot(2,4,5)
imshow(log_edges, [])
title("log edge detection")
subplot(2,4,6)
imshow(zc_edges, [])
title("zerocross edge detection")
subplot(2,4,7)
imshow(canny_edges, [])
title("canny edge detection")

disk = load("disk_img.mat").disk_img;
sobel_disk = edge(disk, "sobel");
figure
subplot(1,2,1)
imshow(disk, [])
subplot(1,2,2)
imshow(sobel_disk, [])



