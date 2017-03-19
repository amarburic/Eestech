function guess = predict(X, theta, threshold)
    if nargin < 3
        threshold = 0.5
    end;
    guess = sigmoid(X * theta) >= threshold;
end