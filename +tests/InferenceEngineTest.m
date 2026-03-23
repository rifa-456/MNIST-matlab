classdef InferenceEngineTest < matlab.unittest.TestCase

    properties
        ModelPath (1,1) string
        Engine    live.inferenceEngine
    end

    methods (TestClassSetup)
        function buildMinimalNetworkFixture(tc)
            layers = [
                imageInputLayer([28 28 1], 'Normalization', 'none', 'Name', 'input')
                fullyConnectedLayer(10, 'Name', 'fc')
                softmaxLayer('Name', 'softmax')
            ];
            net = dlnetwork(layers);
            tc.ModelPath = string([tempname '.mat']);
            save(tc.ModelPath, 'net');
        end
    end

    methods (TestClassTeardown)
        function deleteNetworkFixture(tc)
            if isfile(tc.ModelPath)
                delete(tc.ModelPath);
            end
        end
    end

    methods (TestMethodSetup)
        function createEngine(tc)
            tc.Engine = live.inferenceEngine(tc.ModelPath);
        end
    end

    methods (Test, TestTags = {'unit', 'inference'})

        function outputIs1x10(tc)
            scores = tc.Engine.predict(zeros(28, 28, 1, 'single'));
            tc.verifySize(scores, [1 10]);
        end

        function outputIsDouble(tc)
            scores = tc.Engine.predict(zeros(28, 28, 1, 'single'));
            tc.verifyClass(scores, 'double');
        end

        function allScoresNonNegative(tc)
            scores = tc.Engine.predict(rand(28, 28, 1, 'single'));
            tc.verifyGreaterThanOrEqual(min(scores), 0.0);
        end

        function scoresSumToOne(tc)
            scores = tc.Engine.predict(rand(28, 28, 1, 'single'));
            tc.verifyEqual(sum(scores), 1.0, 'AbsTol', 1e-5, ...
                'Softmax output must sum to 1.');
        end

        function deterministicForIdenticalInput(tc)
            img = rand(28, 28, 1, 'single');
            tc.verifyEqual(tc.Engine.predict(img), tc.Engine.predict(img));
        end

    end
end