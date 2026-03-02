classdef inferenceEngine < handle

    properties (Access = private)
        Net
        NumClasses  (1,1) double
    end

    methods (Access = public)

        function obj = inferenceEngine(modelPath)
            arguments
                modelPath (1,1) string {mustBeFile}
            end

            loaded = load(modelPath, 'net');
            obj.Net = loaded.net;
            obj.NumClasses = 10;
            fprintf('[InferenceEngine] Model loaded from: %s\n', modelPath);
        end

        function scores = predict(obj, img)
            dlImg = dlarray(img, 'SSC');
            raw = extractdata(predict(obj.Net, dlImg));
            scores = double(raw(:))';
        end

    end
end