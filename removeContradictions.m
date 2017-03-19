function [newDataSet] = removeContradictions(dataSet)
    m = size(dataSet, 1);
    newDataSet = [];
    isContradiction = zeros(m, 1);
    for i = 1:m
        for j = (i + 1):m
            if isequal(dataSet(i, 1:end - 1), dataSet(j, 1:end - 1)) ...
                && dataSet(i, end) ~= dataSet(j, end)
                isContradiction([i j]) = 1;
            end;
        end;
        if ~isContradiction(i)
            newDataSet = [newDataSet; dataSet(i, :)];
        end;
    end;
end