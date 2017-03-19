fprintf('Loading data...\n');

load('Data\\TRAIN_1.mat');
load('Data\\TEST_1.mat');
load('Data\\SUPERVISOR_1.mat');

fprintf('Press enter to continue... \n\n');
pause;

fprintf('Normalizing...\n');

mTrain = size(TRAIN_1, 1);
mTest = size(TEST_1, 1);
mSupervisor = size(SUPERVISOR_1, 1);

UNION_1 = [TRAIN_1(:, 1:end - 1); ...
    TEST_1(:, 1:end - 1); ... 
    SUPERVISOR_1(:, 1:end)];

UNION_1NORM = normalize(UNION_1);

TRAIN_1NORM = UNION_1NORM(1:mTrain, :);
TRAIN_1NORM = [TRAIN_1NORM TRAIN_1(:, end)];

TEST_1NORM = UNION_1NORM(mTrain + 1:mTrain + mTest, :);
TEST_1NORM = [TEST_1NORM TEST_1(:, end)];

SUPERVISOR_1NORM = UNION_1NORM(mTrain + mTest + 1:end, :);

fprintf('Press enter to continue... \n\n');
pause;

XTrain = TRAIN_1NORM(:, 1:end - 1);
yTrain = TRAIN_1NORM(:, end);
XTest = TEST_1NORM(:, 1:end - 1);
yTest = TEST_1NORM(:, end);
XSupervisor = SUPERVISOR_1NORM(:, 1:end);

fprintf('Testing ranks...\n');
fprintf('Training set rank: %d \nTest set rank: %d \nSupervisor set rank: %d \n',...
     rank(XTrain), rank(XTest), rank(XSupervisor)); 
fprintf('Press enter to continue...\n\n');
pause;

n = size(XTrain, 2);

fprintf('Finding which feature to remove... \n');

for i = 1:n 
    features = [1:(i - 1) (i + 1):n];
    if rank(XTrain(:, features)) == (n - 1)
        fprintf('Removing feature %d\n', i);
        XTrain = XTrain(:, features);
        XTest = XTest(:, features);
        XSupervisor = XSupervisor(:, features);
        n = n - 1;
        break;
    end;
end;

fprintf('Press enter to continue...\n\n');
pause;

fprintf('Removing contradictions from the train set... \n');
XTrainOld = XTrain;
yTrainOld = yTrain;    
dataSetTrain = removeContradictions([XTrain yTrain]);
XTrain = dataSetTrain(:, 1:end - 1);
yTrain = dataSetTrain(:, end);
fprintf('Old train set size: %d\nNew train set size: %d\n', ...
mTrain, size(XTrain, 1));
mTrain = size(XTrain, 1);
fprintf('Press enter to continue...\n\n');
pause;

fprintf('Removing duplicates...\n');
dataSetTrain = removeDuplicates([XTrain yTrain]);
XTrain = dataSetTrain(:, 1:end - 1);
yTrain = dataSetTrain(:, end);
fprintf('Old train set size: %d\nNew train set size: %d\n', ...
mTrain, size(XTrain, 1));
mTrain = size(XTrain, 1);
fprintf('Press enter to continue...\n\n');
pause;

fprintf('Removing wild examples...\n');

dataSetTrain = removeWildEx([XTrain yTrain]);
XTrain = dataSetTrain(:, 1:end - 1);
yTrain = dataSetTrain(:, end);
fprintf('Old train set size: %d\nNew train set size: %d\n', ...
mTrain, size(XTrain, 1));
mTrain = size(XTrain, 1);
fprintf('Press enter to continue...\n\n');
pause;

fprintf('Training set stats:\n')
percentOfPositives = sum(yTrain) / size(yTrain, 1) * 100;
percentOfNegatives = 100 - percentOfPositives;
fprintf('Positives: %f%%\nNegatives: %f%%\n', percentOfPositives, ...
    percentOfNegatives);
fprintf('Press enter to continue...\n\n');
pause;

XTrainPadded = [ones(size(XTrain, 1), 1) XTrain];
XTestPadded = [ones(size(XTest, 1), 1) XTest];
XSupervisorPadded = [ones(size(XSupervisor, 1), 1) XSupervisor];
XTrainOldPadded = [ones(size(XTrainOld, 1), 1) XTrainOld];
XSupervisorPadded = [ones(size(XSupervisor, 1), 1) XSupervisor];

fprintf('Plotting training data...\n');
plotData(XTrain, yTrain);
fprintf('Press enter to continue...\n\n');
pause;

fprintf('Plotting testing data...\n');
plotData(XTest, yTest);
fprintf('Press enter to continue...\n\n');
pause;

fprintf('Plotting supervisor data...\n');
plotData(XSupervisor, zeros(size(XSupervisor, 1), 1), 1);
fprintf('Press enter to continue...\n\n');
pause;

fprintf('Training logistic regression...\n');

initTheta = zeros(n + 1, 1);
lambdas = [0.01, 0.03, 0.1, 0.3, 1, 3, 10, 30, 100, 300];
maxIter = 100;

[theta, costHistTrain, costHistTest, costHistIter] = ...
    train(XTrainPadded, yTrain, initTheta, lambdas, maxIter, ...
    XTestPadded, yTest);

fprintf('Thetas: \n'); 
fprintf('%f\n', theta);
fprintf('Press enter to continue...\n\n');
pause;

fprintf('Plotting cost functions, as functions of lambda...\n');

figure;
hold on;
xlabel('Lambda');
ylabel('Cost');
plot(lambdas, costHistTrain);
plot(lambdas, costHistTest);
legend('Cost on train set', 'Cost on test set'); 
hold off;

fprintf('Press enter to continue...\n\n');
pause;

fprintf('Plotting cost function, as function of # of iterations...\n');
figure;
plot(1:maxIter, costHistIter); 
xlabel('Number of iterations');
ylabel('Cost');

fprintf('Press enter to continue...\n\n');
pause;

fprintf('Plotting regression curve on the training data...\n');
plotData(XTrain, yTrain);
plotRegCurve(XTrain, theta);
fprintf('Press enter to continue...\n\n');
pause;

fprintf('Plotting regression curve on the testing data...\n');
plotData(XTest, yTest);
plotRegCurve(XTest, theta);
fprintf('Press enter to continue...\n\n');
pause;

predictionThreshold = 0.5; 

fprintf('Plotting regression curve on the supervisor data...\n');
ySupervisorPredicted = predict(XSupervisorPadded, theta, predictionThreshold);
plotData(XSupervisor, ySupervisorPredicted);
plotRegCurve(XSupervisor, theta);
fprintf('Press enter to continue...\n\n');
pause;

fprintf('Calculating accuracy...\n');
[accuracy, precision, recall] = grader(...
    predict(XTrainPadded, theta, predictionThreshold), yTrain);
fprintf('\nOn the train set(without contradictions or extreme examples):\n');
fprintf('Accuracy: %f%%\nPrecision: %f\nRecall: %f\n',...
    accuracy * 100, precision, recall);
[accuracy, precision, recall] = grader(...
    predict(XTrainOldPadded, theta, predictionThreshold), yTrainOld);
fprintf('\nOn the train set(entire set):\n');
fprintf('Accuracy: %f%%\nPrecision: %f\nRecall: %f\n',...
    accuracy * 100, precision, recall);
[accuracy, precision, recall] = grader(...
    predict(XTestPadded, theta, predictionThreshold), yTest);
fprintf('\nOn the test set:\n');
fprintf('Accuracy: %f%%\nPrecision: %f\nRecall: %f\n',...
    accuracy * 100, precision, recall);
fprintf('Press enter to continue...\n\n');
pause;
