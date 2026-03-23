classdef AppControllerTest < matlab.mock.TestCase

    properties
        MockPredictor
        Behavior
        Canvas      live.canvasManager
        Controller  live.appController
    end

    methods (TestMethodSetup)
        function buildFixtures(tc)
            tc.assumeTrue(usejava('desktop'), ...
                'AppControllerTest requires a display — skipped in headless mode.');

            import matlab.unittest.constraints.IsAnything
            [tc.MockPredictor, tc.Behavior] = tc.createMock(?contracts.IPredictor);
            tc.assignOutputsWhen( ...
                tc.Behavior.predict(IsAnything()), ...
                repmat(0.1, 1, 10));
            tc.Canvas = live.canvasManager(280, 12);
            tc.Controller = live.appController(tc.MockPredictor, tc.Canvas);
        end
    end

    methods (TestMethodTeardown)
        function closeFigures(~)
            close all force;
        end
    end

    methods (Test)

        function predictNotCalledBeforeAnyDraw(tc)
            import matlab.unittest.constraints.IsAnything
            tc.verifyNotCalled(tc.Behavior.predict(IsAnything()));
        end

        function predictCalledAfterFirstBrushStroke(tc)
            import matlab.unittest.constraints.IsAnything
            tc.Canvas.startStroke();
            tc.Canvas.applyBrushAt(140, 140);
            tc.verifyCalled(tc.Behavior.predict(IsAnything()));
        end

        function predictCalledExactlyOncePerApplyBrush(tc)
            import matlab.unittest.constraints.IsAnything
            tc.Canvas.startStroke();
            tc.Canvas.applyBrushAt(140, 140);
            tc.verifyThat( ...
                tc.Behavior.predict(IsAnything()), ...
                matlab.mock.constraints.WasCalled('WithCount', 1));
        end

        function predictCalledThreeTimesForThreeStrokes(tc)
            import matlab.unittest.constraints.IsAnything
            tc.Canvas.startStroke();
            tc.Canvas.applyBrushAt(50,  50);
            tc.Canvas.applyBrushAt(100, 100);
            tc.Canvas.applyBrushAt(150, 150);

            tc.verifyThat( ...
                tc.Behavior.predict(IsAnything()), ...
                matlab.mock.constraints.WasCalled('WithCount', 3));
        end

    end
end