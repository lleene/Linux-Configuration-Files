function [B] = string2array(string)
    A = arrayfun(@(c) rgb2gray(insertText(zeros(16, 16, 3), [9 9], c, ...
        'Font', 'LucidaSansRegular', ... You want a non-serif font. Experiment with that
        'FontSize', 20, ...  Experiment with that. size is not pixels
        'AnchorPoint', 'Center', ...
        'TextColor', [1 1 1], ...
        'BoxOpacity', 0) ...
        ) < 0.5, ....  You may want to experiment with the binarisation threshold as well
        string, 'UniformOutput', false);

    B = A{1};
    for i=2:size(A,2)
        B = [B A{i}];
    end
end