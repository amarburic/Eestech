function [theta, costHistory] = gradientDescent(...
    X, y, theta, lambda, maxIter, stepSize)
    costHistory = [];
    for i = 1:maxIter
        [cost, grad] = costFunction(X, y, theta, lambda);
        theta = theta - stepSize * grad;
        costHistory = [costHistory; cost];
    end;
end