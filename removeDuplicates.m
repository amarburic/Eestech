function reducedDataSet = removeDuplicates(dataSet) 
    m = size(dataSet, 1);
    isDuplicate = zeros(m, 1);
    reducedDataSet = [];
    for i = 1:m
        for j = (i + 1):m
            if isequal(dataSet(i, :), dataSet(j, :))
                isDuplicate(j) = 1;
            end;
        end;
        if ~isDuplicate(i)
            reducedDataSet = [reducedDataSet; dataSet(i, :)];
        end;
    end;
end
            