function [accuracy, precision, recall] = grader(guess, y)
    tp = sum(guess & y);
    tn = sum(~(guess | y));
    fp = sum(guess & xor(guess, y));
    fn = sum(y & xor(guess, y));
    accuracy = (tp + tn) / (tp + tn + fp + fn);
    precision = tp / (tp + fp);
    recall = tp / (tp + fn);
end