function live_classify()

clc;

if ~exist('trained_mnist_model.mat', 'file')
    error('Run train_model.m first.');
end
load('trained_mnist_model.mat', 'net');
disp('Model loaded. Draw a digit!');

canvasSize  = 280;
modelSize   = 28;
brushRadius = 12;

canvas    = zeros(canvasSize, canvasSize, 'single');
isDrawing = false;

fig = uifigure('Name', 'MNIST Live Classifier', ...
    'Position', [100 100 700 350], ...
    'Color', [0.15 0.15 0.15]);

drawAx = uiaxes(fig, ...
    'Position', [10 10 330 330], ...
    'XLim',     [1 canvasSize], ...
    'YLim',     [1 canvasSize], ...
    'XTick',    [], ...
    'YTick',    [], ...
    'Color',    'k');
title(drawAx, 'Draw here', 'Color', 'w');
canvasImg = imshow(canvas, [0 1], 'Parent', drawAx);

predLabel = uilabel(fig, ...
    'Position',            [370 250 300 80], ...
    'Text',                '?', ...
    'FontSize',            72, ...
    'FontWeight',          'bold', ...
    'FontColor',           [0.2 1 0.4], ...
    'HorizontalAlignment', 'center', ...
    'BackgroundColor',     [0.15 0.15 0.15]);

confLabel = uilabel(fig, ...
    'Position',            [370 210 300 40], ...
    'Text',                'Confidence: -', ...
    'FontSize',            16, ...
    'FontColor',           [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'center', ...
    'BackgroundColor',     [0.15 0.15 0.15]);

barAx = uiaxes(fig, ...
    'Position',   [370 20 310 185], ...
    'Color',      [0.2 0.2 0.2], ...
    'XColor',     'w', ...
    'YColor',     'w', ...
    'XLim',       [0.5 10.5], ...
    'YLim',       [0 1], ...
    'XTick',      1:10, ...
    'XTickLabel', {'0','1','2','3','4','5','6','7','8','9'});
title(barAx, 'Class probabilities', 'Color', 'w');
ylabel(barAx, 'Softmax score', 'Color', 'w');
barChart = bar(barAx, 1:10, zeros(1,10), ...
    'FaceColor', [0.2 0.6 1], ...
    'EdgeColor', 'none');

uibutton(fig, ...
    'Position',        [10 5 100 30], ...
    'Text',            'Clear Canvas', ...
    'ButtonPushedFcn', @(~,~) clearCanvas());

fig.WindowButtonDownFcn   = @(~,~) startDraw();
fig.WindowButtonUpFcn     = @(~,~) stopDraw();
fig.WindowButtonMotionFcn = @(~,~) onMouseMove();

    function startDraw()
        isDrawing = true;
        onMouseMove();
    end

    function stopDraw()
        isDrawing = false;
    end

    function onMouseMove()
        if ~isDrawing, return; end

        pt = drawAx.CurrentPoint;
        x  = round(pt(1,1));
        y  = round(pt(1,2));

        if x < 1 || x > canvasSize || y < 1 || y > canvasSize
            return;
        end

        [xx, yy] = meshgrid(1:canvasSize, 1:canvasSize);
        dist     = sqrt((xx - x).^2 + (yy - y).^2);
        brush    = exp(-dist.^2 / (2 * (brushRadius/2)^2));

        canvas          = min(1, canvas + single(brush));
        canvasImg.CData = canvas;

        runInference();
    end

    function clearCanvas()
        canvas          = zeros(canvasSize, canvasSize, 'single');
        canvasImg.CData = canvas;
        predLabel.Text  = '?';
        confLabel.Text  = 'Confidence: -';
        barChart.YData  = zeros(1, 10);
    end

    function runInference()
        img = imresize(canvas, [modelSize modelSize]);
        img   = reshape(img, modelSize, modelSize, 1);
        dlImg = dlarray(img, 'SSC');

        scores = predict(net, dlImg);
        scores = double(extractdata(scores(:)))';

        [confidence, idx] = max(scores);
        digit             = idx - 1;

        predLabel.Text = num2str(digit);
        confLabel.Text = sprintf('Confidence: %.1f%%', confidence * 100);
        barChart.YData = scores;

        colors        = repmat([0.2 0.6 1], 10, 1);
        colors(idx,:) = [0.2 1 0.4];
        barChart.FaceColor = 'flat';
        barChart.CData     = colors;

        drawnow limitrate;
    end

end