classdef canvasManager < handle

    events
        CanvasUpdated
    end

    properties (SetAccess = private)
        SizePx (1,1) double
    end

    properties (Access = private)
        Pixels (:,:) single
        BrushRadius (1,1) double
        IsDrawing (1,1) logical = false

        GridX (:,:) double
        GridY (:,:) double
    end

    methods (Access = public)

        function obj = canvasManager(canvasSizePx, brushRadius)
            arguments
                canvasSizePx (1,1) double {mustBePositive, mustBeInteger} = 280
                brushRadius (1,1) double {mustBePositive} = 12
            end

            obj.SizePx      = canvasSizePx;
            obj.BrushRadius = brushRadius;
            obj.Pixels      = zeros(canvasSizePx, canvasSizePx, 'single');

            [obj.GridX, obj.GridY] = meshgrid(1:canvasSizePx, 1:canvasSizePx);
        end

        function pixels = getPixels(obj)
            pixels = obj.Pixels;
        end

        function img = getSnapshot(obj)
            img = imresize(obj.Pixels, [28 28]);
            img = reshape(img, 28, 28, 1);
        end

        function clear(obj)
            obj.Pixels = zeros(obj.SizePx, obj.SizePx, 'single');
            notify(obj, 'CanvasUpdated');
        end

        function startStroke(obj)
            obj.IsDrawing = true;
        end

        function endStroke(obj)
            obj.IsDrawing = false;
        end

        function painted = applyBrushAt(obj, x, y)
            painted = false;

            if ~obj.IsDrawing
                return;
            end

            if x < 1 || x > obj.SizePx || y < 1 || y > obj.SizePx
                return;
            end

            sigma  = obj.BrushRadius / 2;
            brush  = exp(-((obj.GridX - x).^2 + (obj.GridY - y).^2) / (2 * sigma^2));
            obj.Pixels = min(1, obj.Pixels + single(brush));

            painted = true;
            notify(obj, 'CanvasUpdated');
        end

    end
end