prostate = load("prostate.mat").PM;
lesion_noise = load("lesionNoise.mat").I1;

% figure
% subplot(1,2,1)
% imshow(prostate, [])
% subplot(1,2,2)
% imshow(lesion_noise, [])

% Question 1

% removing noise
lesion_p = lesion_noise .* prostate;
figure
imshow(lesion_p)
title("lesion image only containing data inside prostate")

% hole filling
lesion_hole_fill = imfill(lesion_p, 'holes');
figure
imshow(lesion_hole_fill)
title("lesion image after filling holes in lesions")

% opening
% creating structuring element
B = create_struct(14);

% applying opening operation
lesion_opened = imopen(lesion_hole_fill,B);

% display
figure
imshow(lesion_opened)
title("lesion image after being opened")

% Question 2

% boundary extraction
% dilated image
lesion_dilated = imdilate(lesion_opened, create_struct(10));
figure
imshow(lesion_dilated)
title("dilated lesion")

% subtracting
lesion_boundary = lesion_dilated - lesion_opened;
imshow(lesion_boundary)
title("peri-tumoral region")

% final
figure
subplot(2,2,1)
imshow(lesion_noise)
title("(A) lesion")
subplot(2,2,2)
imshow(prostate)
title("(B) prostate")
subplot(2,2,3)
imshow(lesion_opened)
title("(C) clinically relevant")
subplot(2,2,4)
imshow(lesion_boundary)
title("(D) peri-tumoral")

% functions

% create structuring element
function B = create_struct(size)

[cols, rows] = meshgrid(1:size,1:size);
center = size/2;
r = round(size/3);
B = double((rows - center).^2 + (cols - center).^2 <= r.^2);

end


