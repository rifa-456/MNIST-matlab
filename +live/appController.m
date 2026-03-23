classdef appController < handle
    
    properties (Access = private)
        Canvas live.canvasManager
        Inference live.inferenceEngine
        Display live.displayPanel
    end
    
    methods (Access = public)
    
        function obj = appController()
            modelPath = fullfile(pwd, 'trained_mnist_model.mat');
            obj.Inference = live.inferenceEngine(modelPath);
            obj.Canvas = live.canvasManager(280, 12);
            obj.Display = live.displayPanel(obj.Canvas, @obj.onClearRequested);

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