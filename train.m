function [bestTheta, costHistTrain, costHistTest, bestCostHistIter] ...
    = train(X, y, initTheta, lambdas, maxIter, XTest, yTest)
    costHistTrain = [];
    costHistTest = [];
    minCost = 1e10;
    bestTheta = [];
    bestCostHistIter = [];
    for lambda = lambdas 
%         options = optimset('GradObj', 'on', 'MaxIter', maxIter);
%         [theta, cost, ~] = fminunc(@(t)(costFunction(X, y, t, lambda)), initTheta, ...
%             options);
        [theta, costHistIter] = gradientDescent(...
            X, y, initTheta, lambda, maxIter, 1);
        if costHistIter(end) < minCost
            minCost = costHistIter(end);
            bestTheta = theta;
            bestCostHistIter = costHistIter;
        end;
        costHistTrain = [costHistTrain; costFunction(X, y, theta, 0)];
        costHistTest = [costHistTest; costFunction(XTest, yTest, theta, 0)];
    end;
end