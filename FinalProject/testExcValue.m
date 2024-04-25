% one of the challenges with computing the error is that increasing spike
% counts increases the value of the integrated signal. If the value of the
% integrated signal could be standardized, it would be easier to assess the
% error between different spike trains and methods.

% the purpose of this script is to analyze the relationship between
% simulation excitability (and therefore spike counts) and the mean and
% maximum value of the integrated signal. 
clc; clear; close all;

load('sampledata.mat')
D = dir();

method = 'FE'
for ii = 3:length(D)
    if ~contains(D(ii).name, method)
        continue
    end
    
    expdata = load(D(ii).name);

    exc = str2num(D(ii).name(16:18))/4;
    subplot(311)
    hold on
    scatter(exc, mean(expdata.Sint)/exc)
    subplot(312)
    hold on
    scatter(exc, max(expdata.Sint)/exc)
    subplot(313)
    hold on
    plot(expdata.data.spiketimes, expdata.Sint/exc)

end
hold on
plot(sampledata.t, sampledata.F - sampledata.F(1))

% results show scaling the integrated signal by the excitability normalizes
% the integrated signals well, with mean(S)/exc and max(S)/exc showing flat
% trends aside from at low excitability levels. This tracks with the
% supposition that error is greater with fewer spikes