classdef PreprocessImageTest < matlab.unittest.TestCase

    properties (TestParameter)
        NumChannels = struct('grayscale', 1, 'rgb', 3)
        SizePx      = struct('small', 14, 'large', 64)
    end

    methods (Test, ParameterCombination = 'exhaustive', TestTags = {'unit', 'data'})

        function outputIs28x28x1(tc, NumChannels, SizePx)
            tmpFile    = tc.writeSyntheticImage(SizePx, NumChannels);
            cleanupObj = onCleanup(@() delete(tmpFile)); %#ok<NASGU>
            img        = data.preprocessImage(tmpFile);
            tc.verifySize(img, [28 28 1], ...
                'Output must be [28 28 1] regardless of input size or channels.');
        end

        function outputIsSingle(tc, NumChannels, SizePx)
            tmpFile    = tc.writeSyntheticImage(SizePx, NumChannels);
            cleanupObj = onCleanup(@() delete(tmpFile)); %#ok<NASGU>
            img        = data.preprocessImage(tmpFile);
            tc.verifyClass(img, 'single');
        end

        function outputValuesInUnitRange(tc, NumChannels, SizePx)
            tmpFile    = tc.writeSyntheticImage(SizePx, NumChannels);
            cleanupObj = onCleanup(@() delete(tmpFile)); %#ok<NASGU>
            img        = data.preprocessImage(tmpFile);
            tc.verifyGreaterThanOrEqual(min(img(:)), single(0));
            tc.verifyLessThanOrEqual(   max(img(:)), single(1));
        end

    end

    methods (Access = private, Static)
        function path = writeSyntheticImage(sizePx, channels)
            path = [tempname '.png'];
            if channels == 1
                pixels = uint8(randi([0 255], sizePx, sizePx));
            else
                pixels = uint8(randi([0 255], sizePx, sizePx, 3));
            end
            imwrite(pixels, path);
        end
    end
end