function plotRegCurve(dataSet, theta)
    [xMin, yMin] = min(dataSet(:, 1:2));
    [xMax, yMax] = min(dataSet(:, 1:2));
    xRange = -5:0.1:5;
    yRange = -5:0.1:5;
    [X, Y] = meshgrid(xRange, yRange);
    Z = (theta(1) + theta(2) * X + theta(3) * Y) / (-theta(4));
    hold on;
    mesh(X, Y, Z);
    hold off;
end