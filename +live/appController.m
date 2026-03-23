classdef appController < handle

    properties (Access = private)
        Canvas live.canvasManager
        Inference
        Display live.displayPanel
    end

    methods (Access = public)

        function obj = appController(inferenceObj, canvas)
            if nargin < 2 || isempty(canvas)
                canvas = live.canvasManager(280, 12);
            end
            if nargin < 1 || isempty(inferenceObj)
                inferenceObj = live.inferenceEngine( ...
                    fullfile(pwd, 'trained_mnist_model.mat'));
            end

            obj.Canvas    = canvas;
            obj.Inference = inferenceObj;
            obj.Display   = live.displayPanel(obj.Canvas, @obj.onClearRequested);

            addlistener(obj.Canvas, 'CanvasUpdated', @obj.onCanvasUpdated);
        end

        function run(obj)
            obj.Display.show();
        end

    end

    methods (Access = private)

        function onCanvasUpdated(obj, ~, ~)
            scores = obj.Inference.predict(obj.Canvas.getSnapshot());
            obj.Display.updatePrediction(scores);
        end

        function onClearRequested(obj)
            obj.Canvas.clear();
            obj.Display.resetPrediction();
        end

    end
end