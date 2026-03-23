clc; clear; close all;

load('trained_mnist_model.mat', 'net');
disp('dlnetwork loaded.');

params   = config.getHyperparams();
testDir  = fullfile(params.DataDir, 'test');

imdsTest = imageDatastore(testDir, ...
    'IncludeSubfolders', true, ...
    'LabelSource', 'foldernames');
imdsTest.ReadFcn = @(p) im2single(imresize(imread(p), [28 28]));

scores = minibatchpredict(net, imdsTest, ...
    'ExecutionEnvironment', params.ExecutionEnvironment);

classNames = categories(imdsTest.Labels);
predictedLabels = scores2label(scores, classNames);

trueLabels = imdsTest.Labels;
accuracy = mean(predictedLabels == trueLabels) * 100;
fprintf('Test Accuracy: %.2f%%\n', accuracy);

figure;
confusionchart(trueLabels, predictedLabels);
title('MNIST Confusion Matrix');