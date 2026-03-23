classdef HyperparamsTest < matlab.unittest.TestCase

    properties
        Params
    end

    methods (TestClassSetup)
        function loadParams(tc)
            tc.Params = config.getHyperparams();
        end
    end

    methods (Test)

        function hasMaxEpochs(tc)
            tc.verifyTrue(isfield(tc.Params, 'MaxEpochs'));
            tc.verifyClass(tc.Params.MaxEpochs, 'double');
        end

        function hasMiniBatchSize(tc)
            tc.verifyTrue(isfield(tc.Params, 'MiniBatchSize'));
            tc.verifyClass(tc.Params.MiniBatchSize, 'double');
        end

        function hasInitialLearnRate(tc)
            tc.verifyTrue(isfield(tc.Params, 'InitialLearnRate'));
            tc.verifyClass(tc.Params.InitialLearnRate, 'double');
        end

        function hasDataDir(tc)
            tc.verifyTrue(isfield(tc.Params, 'DataDir'));
            tc.verifyTrue(ischar(tc.Params.DataDir) || isstring(tc.Params.DataDir));
        end

        function hasExecutionEnvironment(tc)
            tc.verifyTrue(isfield(tc.Params, 'ExecutionEnvironment'));
        end

        function maxEpochsIsPositiveInteger(tc)
            v = tc.Params.MaxEpochs;
            tc.verifyGreaterThan(v, 0);
            tc.verifyEqual(v, floor(v), ...
                'MaxEpochs must be an integer value.');
        end

        function miniBatchSizeIsPositiveInteger(tc)
            v = tc.Params.MiniBatchSize;
            tc.verifyGreaterThan(v, 0);
            tc.verifyEqual(v, floor(v), ...
                'MiniBatchSize must be an integer value.');
        end

        function initialLearnRateIsPositive(tc)
            tc.verifyGreaterThan(tc.Params.InitialLearnRate, 0);
        end

        function executionEnvironmentIsValid(tc)
            valid = {'auto', 'cpu', 'gpu', 'multi-gpu'};
            tc.verifyTrue(ismember(tc.Params.ExecutionEnvironment, valid), ...
                sprintf('"%s" is not a recognised execution environment.', ...
                    tc.Params.ExecutionEnvironment));
        end

    end
end