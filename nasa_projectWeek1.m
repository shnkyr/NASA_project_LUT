%% NASA Turbofan Project B2
% Data Summary and Visualization

clc;
clear all;

% Performing Explanatory analysis and Descriptive Statistics using Train file
train1 = load("data/train_FD001.txt");

variables =["unit number","time in cycles","Operational setting 1","Operational setting 2","Operational setting 3","sensor measurement 1","sensor measurement 2","sensor measurement 3","sensor measurement 4","sensor measurement5","sensor measurement 6","sensor measurement 7","sensor measurement 8","sensor measurement 9","sensor measurement 10","sensor measurement 11","sensor measurement 12","sensor measurement 13","sensor measurement 14","sensor measurement 15","sensor measurement 16","sensor measurement 17","sensor_measurement 18","sensor measurement 19","sensor measurement 20","sensor measurement 21"];

%check for any null or missing value 
missValue = max(sum(ismissing(train1)));
missValue

meanTrain = mean(train1);
medianTrain = median(train1);
stdDevTrain = std(train1);
rangeTrain = range(train1);

% Finding the outliers using the z-score method in dataset
z_threshold = 3;
Train1Outlier = find(abs(zscore(train1)) > z_threshold);

% Display the results
disp('Descriptive Statistics Summary :');
disp(['Mean: ', num2str(meanTrain)]);
disp(['Median: ', num2str(medianTrain)]);
disp(['Standard Deviation: ', num2str(stdDevTrain)]);
disp(['Range: ', num2str(rangeTrain)]);
disp(['Number of Outliers: ', num2str(length(Train1Outlier))]);

% presenting in table for better understanding from array
arraytable = array2table(train1, 'VariableNames', variables);
arraytable

summary(arraytable) % looking for Min,Max and Median of the variables


%% Visualize with Box Plot, Correlation Plot, Histogram Plot, Time Series Plot

% Plotting all varibales in box plot excluding frist 2 with  no any sense
figure;
boxplot(arraytable{:, 3:end}); % Excluding the first two columns
xlabel('Variables');
ylabel('Values');
title('Box Plot of Variables');
xticklabels(variables(3:end)); 
xtickangle(50); 


% now we will see the relation between each variables to find major factor 

correlation = corr(train1);
map = heatmap(correlation, 'MissingDataColor', 'w');
labels = variables;
map.XDisplayLabels = labels;
map.YDisplayLabels = labels;
title('Correlation between all the Variables');
set(gcf, 'Position', [100, 100, 800, 800]);

% Using histogram to visualize the distribution of each variable.

numBins = 20; 
figure;
% we use loop here to create subplots in single window figure
for variableIndex = 1:numel(variables)
    data = train1(:, variableIndex); %each variables data are extracted here
    subplot(5, 6, variableIndex); %rows and column are defined here
    histogram(data, numBins);
    xlabel(variables(variableIndex));
    ylabel('Frequency');
    title(['Histogram of ' variables(variableIndex)]);
    grid on;
end 
sgtitle('Histograms of Train Dataset Variables'); 

% Now, Plot for the Time Series of all Variables

timeCycle = train1(:, 2);
vecTime = 1:length(timeCycle);
figure;
for variableIndex = 3:numel(variables)
    data = train1(:, variableIndex); %we extract data 
   subplot(5, 6, variableIndex - 2); 
    plot(vecTime, data);
    xlabel('Time');
    ylabel(variables(variableIndex));
    title(['Time Series Plot for ' variables(variableIndex)]);
    grid on;
end
sgtitle('Time Series Plots of Train 1 Dataset Variables'); 


