function params = getHyperparams()
    params.MaxEpochs        = 10;
    params.MiniBatchSize    = 128;
    params.InitialLearnRate = 0.01;
    params.DataDir          = fullfile(pwd, 'data_raw');
    params.ExecutionEnvironment = 'auto';
end