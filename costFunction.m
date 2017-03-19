function [J, grad] = costFunction(X, y, theta, lambda)
    m = size(X, 1);
    sigArg = X * theta;
    J = -(1 / m) * (y' * log(sigmoid(sigArg)) + ...
        (1 - y)' * log(1 - sigmoid(sigArg))) + ...
        lambda / (2 * m) * (theta(2:end)' * theta(2:end));
    grad = (1 / m) * X' * (sigmoid(sigArg) - y);
%     J = (1 / (2 * m)) * ((sigArg - y)' * (sigArg - y) + ...
%         theta(2:end)' * theta(2:end));
%     grad = (1 / m) * X' * (sigArg - y);
    grad(2:end) = grad(2:end) + lambda / m * theta(2:end);
end