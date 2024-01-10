clear
close all

dataset = 1;
[K, img_names, init_pair, pixel_threshold] = get_dataset_info(dataset);
im_1 = imread("../data/1/kronan1.jpg");
im_2 = imread("../data/1/kronan2.jpg");

vl_setup

% figure(1)
% imshow(im_1)
% figure(2)
% imshow(im_2)

[ fA dA ] = vl_sift(single(rgb2gray(im_1)));
[ fB dB ] = vl_sift(single(rgb2gray(im_2)));
disp("Image 1 features number:")
disp(length(fA))
disp("Image 2 features number:")
disp(length(fB))
matches = vl_ubcmatch( dA , dB );
disp("Number of matches:")
disp(length(matches))
xA = fA(1:2 , matches(1 ,:));
xB = fB(1:2 , matches(2 ,:));

x1 = [xA; ones(1, length(xA))];
x2 = [xB; ones(1, length(xB))];

x1_n = pflat(inv(K) * x1);
x2_n = pflat(inv(K) * x2);

save("data_1_matches", "x1", "x2_n", "x1_n", "x2")