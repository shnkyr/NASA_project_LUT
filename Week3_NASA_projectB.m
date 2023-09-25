%% NASA Turbofan Project B2
% Week3_Task

%1. Loading the train data for test and validation
clc 
clear all
close all

% Load Data
data = readmatrix('data/train_FD001.txt');
newVars =["unit number","time in cycles","Operational setting 1","Operational setting 2","Operational setting 3","sensor measurement 1","sensor measurement 2","sensor measurement 3","sensor measurement 4","sensor measurement5","sensor measurement 6","sensor measurement 7","sensor measurement 8","sensor measurement 9","sensor measurement 10","sensor measurement 11","sensor measurement 12","sensor measurement 13","sensor measurement 14","sensor measurement 15","sensor measurement 16","sensor measurement 17","sensor_measurement 18","sensor measurement 19","sensor measurement 20","sensor measurement 21"];

%here above code loads data from a file and defines a set of variable names for different sensor measurements and operational settings.


%2.  Division of data to test and validation (8:2)

trainDataSize = 0;
for i = 1:80
    cyctime = data(:, 1) == i;
    trainDataSize = trainDataSize + sum(cyctime);
end

trainData = data(1:trainDataSize,:);
testingData = data(trainDataSize+1:end,:);

%here a loop iterates through cycles (indexed by i) and calculates the trainDataSize by counting the number of rows in the data matrix where the first column matches the current cycle number i. 
% Then, we splits the data into training and testing Data based on this calculated trainDataSize.


% now we remove null or zero SD value in those sensor and only keep valuable data here
trainData(:,[6, 10, 11, 15, 21, 23, 24]) = [];
newVars(:,[6, 10, 11, 15, 21, 23, 24]) = [];
trainDataTable = array2table(trainData, 'VariableNames', newVars); %table from array conversion

% taking sensor data so fulfil the requirement analysis
sensorData = trainData(:,6:end);

%here in above code we are removing the specific columns from the trainData matrix, adjusts the corresponding variable names, converts trainData into a table, and extracts sensor data for analysis.


%3.  Using Z-Score to normalize the sensor data
normalizedData = zscore(sensorData);
normalizedDataTable = array2table(normalizedData, 'VariableNames', newVars(6:end));

%now the sensor data is normalized, so plotting it to see the differences
figure;
boxplot(normalizedDataTable{:,:});
xlabel('Variables'); ylabel('Values');
title('Normalized Sensor Data Plot');
xticklabels(newVars(6:end));
xtickangle(50); 

%here in above code, we normalizes the sensor data, created a table with normalized values and appropriate variable names, and then we plot a boxplot to visualize the differences in the normalized sensor data.


%4. Now, on Sensor data we will perform PCA 

[coefficients, scores, latent, T2W, explained] = pca(normalizedData);

explained
figure()
pareto(explained);
xlabel('Principal Component')
ylabel('Variance Explained in %')
title("Diff. PC Explaiined Variance ")

%here in above code, we conducted PCA on normalized sensor data, and displayed the explained variance, and visualizes it with a Pareto chart.


%this is how we preprocessed the data of NASA TurboFan Dataset.





%5.  First two Principal Component Biplot
figure
biplot(coefficients(:,1:2),'Scores',scores(:,1:2),'Varlabels',newVars(6:end))
title("First two Principal Component Biplot");

%% For detection of outlier, we will use T2 Square Score

figure('Name', 'T2 Square')
meanT2 = mean(T2W);  %we assume SD here to calculate CL
StdT2 = std(T2W);
UpperLim_T2 = meanT2 + 3 * StdT2; % This is for the outlier boundry

a = 1:length(T2W);
plot(a, T2W), hold on
plot(a, UpperLim_T2*ones(size(T2W)),'r--')
ylabel("T2 Square");

scores = scores(T2W > UpperLim_T2 == 0, :); %score matrix outliers removal and plotting it to see diff. 
figure
biplot(coefficients(:,1:2),'Scores',scores(:,1:2),'Varlabels',newVars(6:end))
title("First two Principal Component Biplot(After Removal)");
