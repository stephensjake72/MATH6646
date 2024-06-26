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

method = 'AB3'
for ii = 3:length(D)
    if ~contains(D(ii).name, method)
        continue
    end
    
    expdata = load(D(ii).name);

    f = find(D(ii).name == '_');
    % k = .05*str2num(D(ii).name(f(3)+5:f(4)-1));
    k = length(expdata.Sint)/2.5;

    subplot(311)
    hold on
    scatter(k, mean(expdata.Sint)/k)
    subplot(312)
    hold on
    scatter(k, max(expdata.Sint)/k)
    subplot(313)
    hold on
    plot(expdata.data.spiketimes, expdata.Sint/k)

end
hold on
plot(sampledata.t, sampledata.F - sampledata.F(1))

% results show scaling the integrated signal by the spike count normalizes
% the integrated signals well, with mean(S)/sc and max(S)/sc showing 
% relatively flat trends aside from at low excitability levels. This tracks
% with the supposition that error is greater with fewer spikes