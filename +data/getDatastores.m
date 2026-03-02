function [imdsTrain, imdsValidation] = getDatastores(dataDir)
    trainDir = fullfile(dataDir, 'train');
    
    if ~exist(trainDir, 'dir')
        error('data:notFound', ...
            'Training data not found at %s. Run utils.downloadMNIST() first.', trainDir);
    end

    imds = imageDatastore(trainDir, ...
        'IncludeSubfolders', true, ...
        'LabelSource',       'foldernames');

    [imdsTrain, imdsValidation] = splitEachLabel(imds, 0.8, 'randomized');
    
    imdsTrain.ReadFcn = @(path) preprocessImage(path);
    imdsValidation.ReadFcn = @(path) preprocessImage(path);
    
    fprintf('Train samples: %d | Validation samples: %d\n', ...
        numel(imdsTrain.Files), numel(imdsValidation.Files));
end

function img = preprocessImage(imagePath)
    img = imread(imagePath);
    img = im2single(img);
    img = imresize(img, [28 28]);
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
end