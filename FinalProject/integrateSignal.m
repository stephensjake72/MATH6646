clc; clear; close all;

load('sampledata.mat')
D = dir();

for ii = 1:length(D)
    if contains(D(ii).name, 'spikeTrain')
        data = load(D(ii).name);
        alpha = .075;
        method = 'FE';
        Sint = integrateSpikes(data.spiketimes, data.ifr, alpha, 'FE');
        error = computeError(data.spiketimes, sampledata.t, sampledata.F, Sint);
        savename = ['results_' method D(ii).name(11:end)];
        save(savename, 'Sint', 'data', 'error')
    end
end