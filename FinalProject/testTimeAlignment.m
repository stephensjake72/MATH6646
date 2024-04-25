% computing the error presents the challenge of how to align the signals in
% time. 
clc
clear
close all

load('sampledata.mat')
D = dir();


for ii = 1:numel(D)
    if ~contains(D(ii).name, 'FE')
        continue
    end
    expdata = load(D(ii).name);

    stshift = expdata.data.spiketimes(end);
    hold on
    plot(expdata.data.spiketimes - stshift, expdata.Sint)
end
tshift = sampledata.t(find(sampledata.dF > 0, 1, 'last'));
yyaxis right
plot(sampledata.t - tshift, sampledata.F)