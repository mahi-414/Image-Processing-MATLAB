%% Question 2
contrast1 = im2gray(imread('Contrast1_new.tif', 'tif'));
contrast2 = im2gray(imread('Contrast2_new.tif', 'tif'));

myNCC(contrast1,contrast2);

% figure
% subplot(1,2,1)
% imshow(contrast1, [])
% subplot(1,2,2)
% imshow(contrast2, [])

contrast2s = single(contrast2);

[rows,cols]=size(contrast2s); 

xo=linspace(0,1,cols);
yo=linspace(0,1,rows);
[ox,oy]=meshgrid(xo,yo);
scale=10;
cn=cols*scale;
rn=rows*scale;
xn=linspace(0,1,cn);
yn=linspace(0,1,rn);
[nx,ny]=meshgrid(xn,yn);

contrast2_resize=zeros(rn,cn);
contrast2_resize(:,:) = uint8(interp2(ox,oy,contrast2s(:,:),nx,ny));

xshift = -18;
yshift = -21;
new_im = uint8(ones(rn+xshift,cn+yshift)*255); % new default white image
new_im(1:rn,1:cn) = contrast2_resize;
% contrast2_resize_shift = new_im(xshift+1:end,yshift+1:end);
contrast2_resize_shift = uint8(imtranslate(contrast2_resize, [xshift,yshift], ...
    'FillValues',255));

contrast2_shift = contrast2_resize_shift(1:10:end, 1:10:end);
quant_eval = myNCC(contrast2,contrast2_shift)

subtracted_img = imsubtract(contrast2_shift, contrast1);
figure
imshow(subtracted_img, [])



%% Question 3

contrast1 = im2gray(imread('Contrast1_new.tif', 'tif'));
contrast2 = im2gray(imread('Contrast2_new.tif', 'tif'));

options = optimset('Display','iter',...
'Diagnostics','on',...
'TolX',0.1,...
'TolFun',0.1,...
'DiffMinChange',1,...
'DiffMaxChange',20,...
'LargeScale','off');
options.zero_term_delta = 1;
options.usual_delta = -1;
coords0 = [0 0];
[min_coords, fval] = fminsearchOS(@translate,coords0,options,contrast2,contrast1)

figure
subplot(2,2,1)
imshow(contrast1, [])
title("first contrast image")
subplot(2,2,2)
imshow(contrast2, [])
title("second contrast image")
subplot(2,2,3)
subtracted_img = imsubtract(contrast1, contrast2);
imshow(subtracted_img)
title("subtraction without registration")

contrast2s = single(contrast2);

[rows,cols]=size(contrast2s); 

xo=linspace(0,1,cols);
yo=linspace(0,1,rows);
[ox,oy]=meshgrid(xo,yo);
scale=10;
cn=cols*scale;
rn=rows*scale;
xn=linspace(0,1,cn);
yn=linspace(0,1,rn);
[nx,ny]=meshgrid(xn,yn);

contrast2_resize=zeros(rn,cn);
contrast2_resize(:,:) = uint8(interp2(ox,oy,contrast2s(:,:),nx,ny));

xshift = round(min_coords(1));
yshift = round(min_coords(2));
new_im = uint8(ones(rn+xshift,cn+yshift)*255); % new default white image
new_im(1:rn,1:cn) = contrast2_resize;
% contrast2_resize_shift = new_im(xshift+1:end,yshift+1:end);
contrast2_resize_shift = uint8(imtranslate(contrast2_resize, [xshift,yshift], ...
    'FillValues',255));

contrast2_shift = contrast2_resize_shift(1:10:end, 1:10:end);
subtracted_img_reg = imsubtract(contrast1, contrast2_shift);

subplot(2,2,4)
imshow(subtracted_img_reg)
title("subtracted image with registration")

%% Question 4

tolfun = [0.01,0.1];
diffminchanges = [0.5,1,2];
fvals = [];
min_coords_arr = [];
params = [];
iterations = [];

for i = 1:length(tolfun)
    for j = 1:length(diffminchanges)
            options = optimset('Display','iter',...
            'Diagnostics','on',...
            'TolX',0.1,...
            'TolFun',tolfun(i),...
            'DiffMinChange',diffminchanges(j),...
            'DiffMaxChange',20,...
            'LargeScale','off');
            options.zero_term_delta = 1;
            options.usual_delta = -1;
            coords0 = [0 0];
            [min_coords, fval, ~, output] = fminsearchOS(@translate,coords0,options, ...
                contrast2,contrast1);
            params = [params; tolfun(i) diffminchanges(j)];
            fvals = [fvals; fval];
            min_coords_arr = [min_coords_arr; min_coords];
            iterations = [iterations; getfield(output, 'iterations')];
    end
end

%% display table

t = table(params(:,1), params(:,2), min_coords_arr, fvals, iterations, ...
    'VariableNames', {'TolFun', 'DiffMinChange', 'Coordinates', '1-r', 'iterations'});

fig = uifigure;
uit = uitable(fig, "Data", t, 'ColumnName', t.Properties.VariableNames, ...
'Position', [20 20 650 200]);

%% Question 5

live = im2gray(imread('live_new.tif', 'tif'));
mask = im2gray(imread('mask_new.tif', 'tif'));

options = optimset('Display','iter',...
'Diagnostics','on',...
'TolX',0.01,...
'TolFun',0.01,...
'DiffMinChange',1,...
'DiffMaxChange',20,...
'LargeScale','off');
coords0 = [1 1];
min_coords = fminsearchOS(@translate,coords0,options,mask,live)

masks = single(mask);

[rows,cols]=size(masks); 

xo=linspace(0,1,cols);
yo=linspace(0,1,rows);
[ox,oy]=meshgrid(xo,yo);
scale=10;
cn=cols*scale;
rn=rows*scale;
xn=linspace(0,1,cn);
yn=linspace(0,1,rn);
[nx,ny]=meshgrid(xn,yn);

mask_resize=zeros(rn,cn);
mask_resize(:,:) = uint8(interp2(ox,oy,masks(:,:),nx,ny));

xshift = round(min_coords(1));
yshift = round(min_coords(2));
new_im = uint8(ones(rn+xshift,cn+yshift)*255); % new default white image
new_im(1:rn,1:cn) = mask_resize;
% contrast2_resize_shift = new_im(xshift+1:end,yshift+1:end);
mask_resize_shift = uint8(imtranslate(mask_resize, [xshift,yshift], ...
    'FillValues',255));

mask_shift = mask_resize_shift(1:10:end, 1:10:end);
subtracted_img_reg = imsubtract(live, mask_shift);
subtracted_img = imsubtract(live, mask);

figure
subplot(2,2,1)
imshow(live, [])
subplot(2,2,2)
imshow(mask, [])
subplot(2,2,3)
imshow(subtracted_img, [])
clim([10,25])
title("subtracted image no registration")
subplot(2,2,4)
imshow(subtracted_img_reg, [])
clim([0,25])
title("subtracted image registration")

%% Question 6
live = im2gray(imread('live_new.tif', 'tif'));
mask = im2gray(imread('mask_new.tif', 'tif'));

[D, moving_reg] = imregdemons(mask, live, [50 400 200],...
    'AccumulatedFieldSmoothing',3);

figure
subplot(1,2,1)
imshow(moving_reg, [])
subplot(1,2,2)
quiver(D(:,:,1), D(:,:,2))
axis equal



%% functions

function minr = translate(coords, im1, im2)

im1s = single(im1);

[rows,cols]=size(im1s); 

xo=linspace(0,1,cols);
yo=linspace(0,1,rows);
[ox,oy]=meshgrid(xo,yo);
scale=10;
cn=cols*scale;
rn=rows*scale;
xn=linspace(0,1,cn);
yn=linspace(0,1,rn);
[nx,ny]=meshgrid(xn,yn);

im1_resize=zeros(rn,cn);
im1_resize(:,:) = uint8(interp2(ox,oy,im1s(:,:),nx,ny));

xshift = round(coords(1));
yshift = round(coords(2));
new_im = uint8(ones(rn+xshift,cn+yshift)*255); % new default white image
new_im(1:rn,1:cn) = im1_resize;
% contrast2_resize_shift = new_im(xshift+1:end,yshift+1:end);
im1_resize_shift = uint8(imtranslate(im1_resize, [xshift,yshift], ...
    'FillValues',255));

im1_shift = im1_resize_shift(1:10:end, 1:10:end);

subtracted_img = imsubtract(im2, im1_shift);
% f=figure;
% set(f,'Visible','off');
% imshow(subtracted_img);
% F = getframe(f);

minr = 1-myNCC(im2,im1_shift);

end

function r = myNCC(im1, im2)

avg1 = mean(im1, 'all');
avg2 = mean(im2, 'all');

[rows,cols] = size(im1);

if size(im1)==size(im2)
    sum_num = 0;
    sum_den1 = 0;
    sum_den2 = 0;
    for r=1:rows
        for c=1:cols
            val1 = im1(r,c);
            val2 = im2(r,c);
            num = double((val1-avg1)*(val2-avg2));
            den1 = double((val1-avg1)^2);
            den2 = double((val2-avg2)^2);
            % if (den1 ~= 255 && den1 ~= 0 || den2 ~= 255 && den2 ~= 0)
            %     disp("not 255 and not 0")
            % end
            sum_num = sum_num+num;
            sum_den1 = sum_den1+den1;
            sum_den2 = sum_den2+den2;
        end
    end
    r = double(sum_num)/(sqrt(double(sum_den1))*sqrt(double(sum_den2)));
else
    r=0;
end


end
