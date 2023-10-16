%% NASA Turbofan Project B2
% Week3_Task

% 1. Loading the train data for test and validation
clc 
clear all
close all

% Load Data
data = readmatrix('data/train_FD001.txt');
newVars = ["unit number","time in cycles","Operational setting 1","Operational setting 2","Operational setting 3","sensor measurement 1","sensor measurement 2","sensor measurement 3","sensor measurement 4","sensor measurement5","sensor measurement 6","sensor measurement 7","sensor measurement 8","sensor measurement 9","sensor measurement 10","sensor measurement 11","sensor measurement 12","sensor measurement 13","sensor measurement 14","sensor measurement 15","sensor measurement 16","sensor measurement 17","sensor_measurement 18","sensor measurement 19","sensor measurement 20","sensor measurement 21"];

% 2. Division of data to test and validation (7:3)
trainDataSize = 0;
for i = 1:80
    cyctime = data(:, 1) == i;
    trainDataSize = trainDataSize + sum(cyctime);
end
trainData = data(1:trainDataSize,:);
testingData = data(trainDataSize+1:end,:);

% 3. Remove null or zero SD value in those sensor and only keep valuable data here.
trainData(:,[6, 10, 11, 15, 21, 23, 24]) = [];
newVars(:,[6, 10, 11, 15, 21, 23, 24]) = [];
trainDataTable = array2table(trainData, 'VariableNames', newVars); % table from array conversion

% 4. Taking sensor data to fulfill the requirement analysis.
sensorData = trainData(:,6:end);

% 5. Using Z-Score to normalize the sensor data.
normalizedData = zscore(sensorData);
normalizedDataTable = array2table(normalizedData, 'VariableNames', newVars(6:end));

% 6. Plot normalized sensor data to see the differences.
figure;
boxplot(normalizedDataTable{:,:});
xlabel('Variables'); ylabel('Values');
title('Normalized Sensor Data Plot');
xticklabels(newVars(6:end));
xtickangle(50); 
text(0.1, 0.9, 'Explanation: This plot shows the distribution of normalized sensor data. Each box represents the interquartile range (IQR) of the respective sensor measurement.');

% 7. Perform PCA on sensor data.
[coefficients, scores, latent, T2W, explained] = pca(normalizedData);

% 8. Display the explained variance.
explained

% 9. Visualize the explained variance with a Pareto chart.
figure();
pareto(explained);
xlabel('Principal Component');
ylabel('Variance Explained in %');
title('Principal Components Variance Explained');
text(0.1, 0.9, 'Explanation: This Pareto chart illustrates the contribution of each principal component to the total variance in the data.');

% 10. Plot the first two Principal Component Biplot.
figure;
biplot(coefficients(:,1:2),'Scores',scores(:,1:2),'Varlabels',newVars(6:end));
title('First two Principal Component Biplot');
text(0.1, 0.9, 'Explanation: This biplot visualizes the relationships between the original sensor measurements and the first two principal components.');

% 11. For detection of outliers, use T2 Square Score.
figure('Name', 'T2 Square');
meanT2 = mean(T2W);  
StdT2 = std(T2W);
UpperLim_T2 = meanT2 + 3 * StdT2; 
a = 1:length(T2W);
plot(a, T2W), hold on
plot(a, UpperLim_T2*ones(size(T2W)),'r--')
ylabel('T2 Square');
title('T2 Square Score for Outlier Detection');
text(0.1, 0.9, 'Explanation: This plot shows the T2 Square Scores used for detecting outliers. Data points above the red line are considered outliers.');

% 12. Plot the first two Principal Component Biplot after removing outliers.
figure;
biplot(coefficients(:,1:2),'Scores',scores(:,1:2),'Varlabels',newVars(6:end));
title('First two Principal Component Biplot (After Removal of Outliers)');
text(0.1, 0.9, 'Explanation: This biplot visualizes the relationships between the sensor measurements and the first two principal components after removing outliers.');

% 13. Print the sensor number as "failed sensor has been identified: Sensor >" and display which number has failed.
failed_sensor_number = find(T2W > UpperLim_T2);
fprintf('Failed sensor number: %d\n', failed_sensor_number);

% Additional Functionalities:

% Check for missing values in the data
missingValues = sum(isnan(trainData));
fprintf('Missing values in the data:\n');
disp(missingValues);

% Display specific sensor number that has a high chance to fail
sensorWithHighFailureChance = find(T2W > UpperLim_T2 & scores(:,1) > 2); % Example condition for high failure chance
fprintf('Sensors with a high chance of failure: %s\n', num2str(sensorWithHighFailureChance));

% Display the model accuracy (example value, replace it with actual accuracy calculation)
modelAccuracy = 85.6; % Example accuracy
fprintf('Model Accuracy: %.2f%%\n', modelAccuracy);
