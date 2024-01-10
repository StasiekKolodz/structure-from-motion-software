function [fA, dA, fB, dB, matches, xA, xB] = find_SIFT(im_1, im_2)
    [ fA, dA ] = vl_sift(single(rgb2gray(im_1)) );
    [ fB, dB ] = vl_sift(single(rgb2gray(im_2)) );
    disp("Image 1 features number:")
    disp(length(fA))
    disp("Image 2 features number:")
    disp(length(fB))
    matches = vl_ubcmatch( dA , dB );
    disp("Number of matches:")
    disp(length(matches))
    xA = fA(1:2 , matches(1 ,:));
    xB = fB(1:2 , matches(2 ,:));
end