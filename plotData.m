function plotData(dataSet, class, unpredicted)
    if nargin < 3
        unpredicted = 0;
    end
    
    positives = class == 1;
    negatives = class == 0;
    
    dataSetPos = dataSet(positives, :);
    dataSetNeg = dataSet(negatives, :);
    
    Xpos = dataSetPos(:, 1);
    Xneg = dataSetNeg(:, 1);
    
    Ypos = dataSetPos(:, 2);
    Yneg = dataSetNeg(:, 2);
    
    Zpos = dataSetPos(:, 3);
    Zneg = dataSetNeg(:, 3);
    
    figure;
    hold on;
    if(unpredicted ~= 1)
        scatter3(Xpos, Ypos, Zpos, '+', 'red');
        scatter3(Xneg, Yneg, Zneg, 'o', 'blue');
        legend('Positives', 'Negatives');
    else 
        scatter3(Xneg, Yneg, Zneg, 'x', 'green');
        legend('Uncertain');
    end;
    hold off;
    
end