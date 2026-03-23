classdef CanvasManagerTest < matlab.unittest.TestCase

    properties
        Canvas live.canvasManager
    end

    methods (TestMethodSetup)
        function createFreshCanvas(tc)
            tc.Canvas = live.canvasManager(280, 12);
        end
    end

    methods (TestMethodTeardown)
        function destroyCanvas(tc)
            delete(tc.Canvas);
        end
    end

    methods (Test, TestTags = {'unit', 'canvas'})

        function sizePxMatchesConstructorArg(tc)
            tc.verifyEqual(tc.Canvas.SizePx, 280);
        end

        function pixelsInitializedToZero(tc)
            tc.verifyEqual(tc.Canvas.getPixels(), zeros(280, 280, 'single'));
        end

        function clearZeroesAllPixels(tc)
            tc.Canvas.startStroke();
            tc.Canvas.applyBrushAt(140, 140);
            tc.Canvas.clear();
            tc.verifyEqual(tc.Canvas.getPixels(), zeros(280, 280, 'single'));
        end

        function brushPaintsWhenDrawing(tc)
            tc.Canvas.startStroke();
            tc.Canvas.applyBrushAt(140, 140);
            tc.verifyGreaterThan(sum(tc.Canvas.getPixels(), 'all'), 0, ...
                'Pixels should be non-zero after a brush stroke.');
        end

        function brushIsNoOpWhenNotDrawing(tc)
            painted = tc.Canvas.applyBrushAt(140, 140);
            tc.verifyFalse(painted);
            tc.verifyEqual(tc.Canvas.getPixels(), zeros(280, 280, 'single'));
        end

        function brushIsNoOpOutsideBounds(tc)
            tc.Canvas.startStroke();
            painted = tc.Canvas.applyBrushAt(9999, 9999);
            tc.verifyFalse(painted);
            tc.verifyEqual(tc.Canvas.getPixels(), zeros(280, 280, 'single'));
        end

        function pixelValuesClampedToOne(tc)
            tc.Canvas.startStroke();
            for i = 1:30
                tc.Canvas.applyBrushAt(140, 140);
            end
            tc.verifyLessThanOrEqual(max(tc.Canvas.getPixels(), [], 'all'), single(1));
        end

        function snapshotIs28x28x1(tc)
            tc.verifySize(tc.Canvas.getSnapshot(), [28 28 1]);
        end

        function snapshotIsSingle(tc)
            tc.verifyClass(tc.Canvas.getSnapshot(), 'single');
        end

        function snapshotValuesInUnitRange(tc)
            tc.Canvas.startStroke();
            tc.Canvas.applyBrushAt(140, 140);
            snap = tc.Canvas.getSnapshot();
            tc.verifyGreaterThanOrEqual(min(snap(:)), single(0));
            tc.verifyLessThanOrEqual(   max(snap(:)), single(1));
        end

        function canvasUpdatedFiresOnBrushStroke(tc)
            counter = tests.EventCounter();
            addlistener(tc.Canvas, 'CanvasUpdated', @counter.increment);
            tc.Canvas.startStroke();
            tc.Canvas.applyBrushAt(140, 140);
            tc.verifyEqual(counter.Count, 1);
        end

        function canvasUpdatedFiresOnClear(tc)
            counter = tests.EventCounter();
            addlistener(tc.Canvas, 'CanvasUpdated', @counter.increment);
            tc.Canvas.clear();
            tc.verifyEqual(counter.Count, 1);
        end

        function canvasUpdatedFiresOncePerApplyBrushCall(tc)
            counter = tests.EventCounter();
            addlistener(tc.Canvas, 'CanvasUpdated', @counter.increment);
            tc.Canvas.startStroke();
            tc.Canvas.applyBrushAt(50,  50);
            tc.Canvas.applyBrushAt(100, 100);
            tc.Canvas.applyBrushAt(150, 150);
            tc.verifyEqual(counter.Count, 3);
        end

    end
end