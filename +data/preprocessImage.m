function img = preprocessImage(imagePath)
    img = imread(imagePath);
    img = im2single(img);
    img = imresize(img, [28 28]);
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    img = max(0, min(1, img));
end