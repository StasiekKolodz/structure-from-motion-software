function images = read_images(img_names, dataset_number)
 for i = 1:length(img_names)
     images{i} = imread("../"+img_names{i});
 end
end