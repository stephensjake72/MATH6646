clc; clear; close all;

load('sampledata.mat')
D = dir();

% iterate through files
for ii = 1:length(D)
    if contains(D(ii).name, 'spikeTrain') % skip files that aren't spike trains
        data = load(D(ii).name);
        alpha = .075;
        methods = {'FE', 'AB2', 'AB3'}; % list of method handles
        
        for jj = 1:length(methods) % iterate through methods
            method = methods{jj};

            % run integration function
            Sint = integrateSpikes(data.spiketimes, data.ifr, alpha, method);

            % compute estimate error
            error = computeError(data.spiketimes, sampledata.t, sampledata.F, Sint, method); % Remove kexc argument
            
            % save
            savename = ['results_' method '_' D(ii).name(11:end)];
            save(savename, 'Sint', 'data', 'error')
        end
    end
end

