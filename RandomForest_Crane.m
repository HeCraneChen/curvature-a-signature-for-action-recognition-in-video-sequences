% Crane Chen hchen136@jhu.edu
% Here we create some training data.
% The rows&lt; represent the samples or individuals.
% The first two columns represent the individual's features.
% The last column represents the class label (what we want to predict)
% n represents the number of features
% x represents the row of new data in testData
function[result]=RandomForest_Crane(trainData, testData, n, x)
    features = trainData(:,(1:n))
    classLabels = trainData(:,n+1)

    % How many trees do you want in the forest? 
    nTrees = 50;

    % Train the TreeBagger (Decision Forest).
    B = TreeBagger(nTrees,features,classLabels, 'Method', 'classification');

    % Given a new individual WITH the features and WITHOUT the class label,
    % what should the class label be?
    newData1 = testData(x,(1:n));

    % Use the trained Decision Forest.
    result = B.predict(newData1);

    % Predictions is a char though. We want it to be a number.
    result = str2double(result);
end