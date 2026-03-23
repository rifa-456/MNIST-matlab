classdef EventCounter < handle
    properties
        Count (1,1) double = 0
    end
    methods
        function increment(obj, ~, ~)
            obj.Count = obj.Count + 1;
        end
    end
end