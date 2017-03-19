function [reducedDataSet] = removeWildEx(dataSet)
    toRemove = round(size(dataSet, 1) / 100);
    reducedDataSet = [];
%     for i = 1:size(dataSet, 2) - 1
%         reducedDataSet = sortrows(reducedDataSet, i);
%         reducedDataSet = reducedDataSet(toRemove + 1:end - toRemove, :);
%     end;
    for i = 1:size(dataSet, 1)
        shouldKeep = 1;
        for j = 1:size(dataSet, 2) - 1
            if(dataSet(i, j) > 1.5)
                shouldKeep = 0;
                break;
            end;
        end;
        if shouldKeep == 1
            reducedDataSet = [reducedDataSet; dataSet(i, :)];
        end;
    end;
