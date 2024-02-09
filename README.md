# ECG-Apnoea-Detection

## Introduction
Our team has investigated methods to automate sleep apnoea detection using ECG data taken from sleeping subjects. The data is used to create a predictive algorithm that is able to label samples as positive for a sleep apnoea episode or negative for normal sleep. This is important because current sleep apnoea detection methods are typically either inaccurate or extremely inconvenient, meaning it is very underdiagnosed. Both MATLAB and Python machine learning methods were utilised in this project to develop optimal model. 

After data preprocessing, QRS detector picked R peaks overlay on ECG signal. A set of time domain features, such as Average of the RR-intervals, logarithmic standard deviation of the intervals, logarithmic standard deviation of the differences between adjacent intervals and RMS of the difference between the intervals, was extracted based on them. 

## Data
|Class|Count|Percentage (%)|
|---|---|---|
|Apnoea|5,922|26.1|
|Normal|16,731|73.9|
|Total|22,653|100|
The dataset used in this project consists of 50 overnight ECG recordings with 1-minute apnea annotations, ECG signals, and QRS detection points. 


## Prediction Result
With a sensitivity of 9.24%, specificity of 97.03%, and an accuracy of 80.63%, our best model demonstrates strong capability in correctly identifying true negatives but has limited effectiveness in detecting true positives.

While the high specificity suggests a low rate of false positives, the low sensitivity indicates a significant number of false negatives. Despite these limitations, the overall accuracy of 80.63% suggests that the model performs reasonably well in distinguishing between positive and negative instances.

However, further improvements are needed, particularly in enhancing sensitivity to ensure a more comprehensive detection of positive cases. By enhancing QRS detection algorithms and fine-tuning more advanced machine learning models, we are optimistic about the eventual development of reliable sleep apnea detection software for users of wearable heart rate monitors.





