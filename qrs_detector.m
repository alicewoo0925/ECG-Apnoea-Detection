clear all
close all
clc

%% load data
fs = 100; % sampling rate
fs_sec = 100*60*60; % sampling rate in second
bit = 0.005; % 1 bit = 5 uV

% load train ecg data
train = load('ProjectTrainData.mat');

% load test ecg data
test = load('ProjectTestECGs.mat');


%% filtering
for i = 1:length(train.ECG)
    ECG_filt_train{i} = filters(train.ECG{i});
end

for i = 1:length(test.ECG)
    ECG_filt_test{i} = filters(test.ECG{i});
end
%% QRS and RR intervals
% QRS
for i = 1:length(ECG_filt_train)
    QRS_train{i} = qrsDetector(ECG_filt_train{i});
end

for i = 1:length(ECG_filt_test)
    QRS_test{i} = qrsDetector(ECG_filt_test{i});
end

% RR intervals
for i=1:length(ECG_filt_train) % training set
   RR_train{i}=diff(QRS_train{i})/100; %RR interval in seconds
   QRS_train{i}(end)=[]; %Make sure two sequences are the same length
   RR_train{i}(RR_train{i}<0.25 | RR_train{i}>2)=nan; %Remove physiologically unreasonable values i.e outside range 0.33s to 3s
end

for i=1:length(ECG_filt_test) % testing set
   disp(i);
   RR_test{i}=diff(QRS_test{i})/100; %RR interval in seconds
   QRS_test{i}(end)=[]; %Make sure two sequences are the same length
   RR_test{i}(RR_test{i}<0.25 | RR_test{i}>2)=nan; %Remove physiologically unreasonable values i.e outside range 0.33s to 3s
end

%% plot the result
% get time
% for i = 1:50
%     t_train{i} = (1:length(ECG_filt_train{i}))/fs_sec; % 100hz in second
%     t_test{i} = (1:length(ECG_filt_test{i}))/fs_sec; % 100hz in second
% end

% figure
% plot(t_train{1},ECG_filt_train{1});
% hold on
% plot(t_train{1}(QRS_train{1}),ECG_filt_train{1}(QRS_train{1}),'ro');
% grid on
% title('train set');
% 
% figure
% plot(t_test{1},ECG_filt_test{1});
% hold on
% plot(t_test{1}(QRS_test{1}),ECG_filt_test{1}(QRS_test{1}),'ro');
% grid on
% title('test set');

%% Save the result
save('ProjectQRS.mat','ECG_filt_train','ECG_filt_test','QRS_train','QRS_test','RR_train','RR_test');
%% Inline functions
% filters
function ECG_filt = filters(ECG)
fs = 100; % sampling rate
fs_sec = 100*60*60; % sampling rate in second
bit = 0.005; % 1 bit = 5 uV

ecg_raw = ECG*bit;
% butterworth low pass filter - remove EMG and powerline interference
fc = 20; % cut off frequency
[b,a] = butter(2,fc/(fs/2),"low"); % butterworth low pass filter
ecg_low = filtfilt(b,a,ecg_raw); % zero-phase digital filtering to deal with dealaying

% median filter - remove baseline interference
median = medfilt1(ecg_low,40); % tried n = 10,20,40,60. I think 40 is ideal.
ecg_median = ecg_low - median;
ECG_filt = ecg_median;
end

% QRS detector
function QRS = qrsDetector(ECG)
% remove outliers before finding maximum
ecg_temp = rmoutliers(ECG,'mean');

r_pmax = max(ecg_temp); % find positive mean
r_nmax = max(-ecg_temp); % find negative mean

% check if ECG is inverted or not
if r_pmax > r_nmax % normal 
    peak_thres = r_pmax*0.90; % peak height threshold is 90% of the maximum
    [~,locs] = findpeaks(ECG,'MinPeakHeight',peak_thres);
else % inverted
    peak_thres = r_nmax*0.90; % peak height threshold is 90% of the maximum
    [~,locs] = findpeaks(-ECG,'MinPeakHeight',peak_thres);
end

sort(locs);
QRS = locs;
end