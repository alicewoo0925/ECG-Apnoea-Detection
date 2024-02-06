clear all
clc

% load test ecg data
load("ProjectTestECGs.mat");

fs = 100; % sampling rate
fs_sec = 100*60*60; % sampling rate in second
bit = 0.005; % 1 bit = 5 uV

%% ECG
% get ECG values
ecg_raw = ECG{10}*bit;
t_ecg = (1:length(ECG{10}))/fs_sec; % 100hz in second

%% filtering
% butterworth low pass filter - remove EMG and powerline interference
fc = 20; % cut off frequency
[b,a] = butter(10,fc/(fs/2),"low"); % butterworth low pass filter
ecg_low = filtfilt(b,a,ecg_raw); % zero-phase digital filtering to deal with dealaying

% median filter - remove baseline interference
median = medfilt1(ecg_low,40); % tried n = 10,20,40,60. I think 40 is ideal.
ecg_median = ecg_low - median;
%% QRS
[~,locs_R] = findpeaks(ecg_median,'MinPeakHeight',1.5);
r_peaks = ecg_median(locs_R); % get R peak values
r_t = t_ecg(locs_R); % get time stamp of each R peak

%% plot 
% plot ECG and QRS
figure
plot(t_ecg,ecg_raw); % original ECG
hold on
plot(t_ecg,median); % median
hold on
plot(t_ecg,ecg_median); % butterworth lowpass + median filtered
hold on
plot(r_t,r_peaks,'ro');
% plot calculated R
% hold on
% plot(r_t,r_peaks,'g*');
% hold off

% add title and axis labels
%xlim([2-0.001 2+0.001]);
title("Test set");
xlabel("Time (hours)");
ylabel("ECG amplitude(mV)");
legend('original ECG','median','median filtered','r peaks');
