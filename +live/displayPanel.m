classdef displayPanel < handle

    properties (Access = private)
        Fig matlab.ui.Figure
        Canvas live.canvasManager
        CanvasImage

        PredLabel matlab.ui.control.Label
        ConfLabel matlab.ui.control.Label
        BarChart

        OnClearCb function_handle
    end

    properties (Constant, Access = private)
        BG_DARK = [0.15 0.15 0.15]
        BG_MID = [0.20 0.20 0.20]
        COL_BLUE = [0.20 0.60 1.00]
        COL_GREEN = [0.20 1.00 0.40]
        COL_LIGHT = [0.80 0.80 0.80]
    end

    methods (Access = public)

        function obj = displayPanel(canvasManager, onClearCallback)
            arguments
                canvasManager   live.canvasManager
                onClearCallback (1,1) function_handle
            end

            obj.Canvas    = canvasManager;
            obj.OnClearCb = onClearCallback;

            obj.buildFigure();
        end

        function show(obj)
            obj.Fig.Visible = 'on';
        end

        function updatePrediction(obj, scores)
            [confidence, idx] = max(scores);

            obj.PredLabel.Text = num2str(idx - 1);
            obj.ConfLabel.Text = sprintf('Confidence: %.1f%%', confidence * 100);
            obj.BarChart.YData = scores;

            colors = repmat(obj.COL_BLUE, 10, 1);
            colors(idx, :) = obj.COL_GREEN;
            obj.BarChart.FaceColor = 'flat';
            obj.BarChart.CData = colors;

            obj.CanvasImage.CData = obj.Canvas.getPixels();

            drawnow limitrate;
        end

        function resetPrediction(obj)
            obj.PredLabel.Text = '?';
            obj.ConfLabel.Text = 'Confidence: -';
            obj.BarChart.YData = zeros(1, 10);
            obj.CanvasImage.CData = obj.Canvas.getPixels();
            drawnow;
        end

    end

    methods (Access = private)

        function buildFigure(obj)
            sz = obj.Canvas.SizePx;

            obj.Fig = uifigure( ...
                'Name', 'MNIST Live Classifier', ...
                'Position', [100 100 700 350], ...
                'Color', obj.BG_DARK, ...
                'Visible', 'off');

            obj.buildDrawingPanel(sz);
            obj.buildPredictionPanel();
            obj.buildBarPanel();
            obj.buildClearButton();
            obj.wireMouseCallbacks();
        end

        function buildDrawingPanel(obj, sz)
            ax = uiaxes(obj.Fig, ...
                'Position', [10 10 330 330], ...
                'XLim', [1 sz], ...
                'YLim', [1 sz], ...
                'XTick', [], ...
                'YTick', [], ...
                'Color', 'k');
            title(ax, 'Draw here', 'Color', 'w');

            obj.CanvasImage = imshow( ...
                zeros(sz, sz, 'single'), [0 1], 'Parent', ax);
        end

        function buildPredictionPanel(obj)
            obj.PredLabel = uilabel(obj.Fig, ...
                'Position', [370 250 300 80], ...
                'Text', '?', ...
                'FontSize', 72, ...
                'FontWeight', 'bold', ...
                'FontColor', obj.COL_GREEN, ...
                'HorizontalAlignment', 'center', ...
                'BackgroundColor', obj.BG_DARK);

            obj.ConfLabel = uilabel(obj.Fig, ...
                'Position', [370 210 300 40], ...
                'Text', 'Confidence: -', ...
                'FontSize', 16, ...
                'FontColor', obj.COL_LIGHT, ...
                'HorizontalAlignment', 'center', ...
                'BackgroundColor', obj.BG_DARK);
        end

        function buildBarPanel(obj)
            ax = uiaxes(obj.Fig, ...
                'Position', [370 20 310 185], ...
                'Color', obj.BG_MID, ...
                'XColor', 'w', ...
                'YColor', 'w', ...
                'XLim', [0.5 10.5], ...
                'YLim', [0 1], ...
                'XTick', 1:10, ...
                'XTickLabel', {'0','1','2','3','4','5','6','7','8','9'});
            title(ax,  'Class probabilities', 'Color', 'w');
            ylabel(ax, 'Softmax score',       'Color', 'w');

            obj.BarChart = bar(ax, 1:10, zeros(1, 10), ...
                'FaceColor', obj.COL_BLUE, ...
                'EdgeColor', 'none');
        end

        function buildClearButton(obj)
            uibutton(obj.Fig, ...
                'Position', [10 5 100 30], ...
                'Text', 'Clear Canvas', ...
                'ButtonPushedFcn', @(~,~) obj.OnClearCb());
        end

        function wireMouseCallbacks(obj)
            obj.Fig.WindowButtonDownFcn = @(~,~) obj.onMouseDown();
            obj.Fig.WindowButtonUpFcn = @(~,~) obj.onMouseUp();
            obj.Fig.WindowButtonMotionFcn = @(~,~) obj.onMouseMove();
        end

        function onMouseDown(obj)
            obj.Canvas.startStroke();
            obj.onMouseMove();
        end

        function onMouseUp(obj)
            obj.Canvas.endStroke();
        end

        function onMouseMove(obj)
            ax = obj.Fig.Children(end);
            pt = ax.CurrentPoint;
            x  = round(pt(1, 1));
            y  = round(pt(1, 2));
            obj.Canvas.applyBrushAt(x, y);
        end

    end
end