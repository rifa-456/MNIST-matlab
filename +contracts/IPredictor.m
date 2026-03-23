classdef (Abstract) IPredictor < handle
    methods (Abstract)
        scores = predict(obj, img)
    end
end