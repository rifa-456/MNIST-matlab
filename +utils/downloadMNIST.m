function downloadMNIST(dataDir)
    trainDir = fullfile(dataDir, 'train');
    testDir  = fullfile(dataDir, 'test');
    if exist(trainDir, 'dir') && exist(testDir, 'dir')
        disp('Data already exists. Skipping download.');
        return;
    end
    disp('Fetching MATLAB built-in digit dataset...');
    sourceDir = fullfile(toolboxdir('nnet'), 'nndemos', 'nndatasets', 'DigitDataset');
    copyfile(sourceDir, dataDir);
    imds = imageDatastore(dataDir, ...
        'IncludeSubfolders', true, ...
        'LabelSource', 'foldernames');
    [imdsTrain, imdsTest] = splitEachLabel(imds, 0.8, 'randomized');
    mkdir(trainDir);
    for i = 1:numel(imdsTrain.Files)
        [~, fname, ext] = fileparts(imdsTrain.Files{i});
        label = string(imdsTrain.Labels(i));
        destFolder = fullfile(trainDir, label);
        if ~exist(destFolder, 'dir'), mkdir(destFolder); end
        copyfile(imdsTrain.Files{i}, fullfile(destFolder, [fname ext]));
    end
    mkdir(testDir);
    for i = 1:numel(imdsTest.Files)
        [~, fname, ext] = fileparts(imdsTest.Files{i});
        label = string(imdsTest.Labels(i));
        destFolder = fullfile(testDir, label);
        if ~exist(destFolder, 'dir'), mkdir(destFolder); end
        copyfile(imdsTest.Files{i}, fullfile(destFolder, [fname ext]));
    end
    disp('Dataset ready.');
end