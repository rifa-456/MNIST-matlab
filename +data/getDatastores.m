function [imdsTrain, imdsValidation] = getDatastores(dataDir)
    trainDir = fullfile(dataDir, 'train');

    if ~exist(trainDir, 'dir')
        error('data:notFound', ...
            'Training data not found at %s. Run utils.downloadMNIST() first.', trainDir);
    end

    imds = imageDatastore(trainDir, ...
        'IncludeSubfolders', true, ...
        'LabelSource', 'foldernames');

    [imdsTrain, imdsValidation] = splitEachLabel(imds, 0.8, 'randomized');

    imdsTrain.ReadFcn = @data.preprocessImage;
    imdsValidation.ReadFcn = @data.preprocessImage;

    fprintf('Train samples: %d | Validation samples: %d\n', ...
        numel(imdsTrain.Files), numel(imdsValidation.Files));
end