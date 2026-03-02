function net = createCNN(inputSize, numClasses)

    arguments
        inputSize  (1,3) double = [28 28 1]
        numClasses (1,1) double = 10
    end

    layers = [
        imageInputLayer(inputSize, 'Normalization', 'none', 'Name', 'input')

        convolution2dLayer(3, 8, 'Padding', 'same', 'Name', 'conv_1')
        batchNormalizationLayer('Name', 'bn_1')
        reluLayer('Name', 'relu_1')
        maxPooling2dLayer(2, 'Stride', 2, 'Name', 'pool_1')

        convolution2dLayer(3, 16, 'Padding', 'same', 'Name', 'conv_2')
        batchNormalizationLayer('Name', 'bn_2')
        reluLayer('Name', 'relu_2')
        maxPooling2dLayer(2, 'Stride', 2, 'Name', 'pool_2')

        fullyConnectedLayer(numClasses, 'Name', 'fc')
        softmaxLayer('Name', 'softmax')
    ];

    net = dlnetwork(layers);

    summary(net);
end