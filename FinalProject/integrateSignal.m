clc; clear; close all;

load('sampledata.mat')
D = dir();

for ii = 1:length(D)
    if contains(D(ii).name, 'spikeTrain')
        data = load(D(ii).name);
        alpha = .075;
        methods = {'FE', 'Trap', 'AB2', 'AB3'};
        
        for jj = 1:length(methods)
            method = methods{jj};
            Sint = integrateSpikes(data.spiketimes, data.ifr, alpha, method);
            error = computeError(data.spiketimes, sampledata.t, sampledata.F, Sint); % Remove kexc argument
            savename = ['results_' method '_' D(ii).name(11:end)];
            save(savename, 'Sint', 'data', 'error')
        end
    end
end

