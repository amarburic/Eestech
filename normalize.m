function [XNorm, mi, sigma] = normalize(X)
    mi = mean(X);
    sigma = std(X);
    XNorm = (X - mi) ./ sigma;
end