clc; clear; close all;
load('sampledata.mat')
spikesample = load('spikeTrain_kRec030_Noise1.mat');

D = dir();
%% Figure 1, example spike sim
figure
subplot(131)
plot(sampledata.t, sampledata.F, 'LineWidth', 2)
subplot(132)
plot(sampledata.t, sampledata.dF, 'LineWidth', 2)
subplot(133)
plot(spikesample.t, spikesample.Vm)
ylim([-80 80])
yyaxis right
plot(spikesample.spiketimes, spikesample.ifr, '.k', 'MarkerSize',  12)
%% Figure 2, ifr and spike count vs receptor gain
figure
n = .06;
for ii = 1:length(D)
    if contains(D(ii).name, 'spikeTrain')
        data = load(D(ii).name);
        subplot(121)
        hold on
        plot(data.spiketimes, data.ifr, '.', 'MarkerSize', 12, 'Color', [0 0 .5] + [1 1 .5]*n)
        xlabel('time'); ylabel('firing rate')
        n = n + .06;

        subplot(122)
        hold on
        scatter(str2num(D(ii).name(16:18)), mean(diff(data.spiketimes)))
        xlabel('receptor gain'); ylabel('mean h_k')
    end
end
%% Figure 3, example accuracy
samplesim1 = load('results_FE_kRec010_Noise1.mat');
samplesim2 = load('results_FE_kRec060_Noise1.mat');

figure
subplot(221)
plot(sampledata.t, sampledata.F)
xlabel('time'); ylabel('s');
yyaxis right
plot(samplesim1.data.spiketimes, samplesim1.Sint, 'Marker', '.')
title(['receptor gain: 10, R^2: ' num2str(samplesim1.error.R2)])
legend({'s', '$$\hat{s}$$'}, 'Interpreter', 'latex')

subplot(222)
plot(sampledata.t, sampledata.F)
yyaxis right
plot(samplesim2.data.spiketimes, samplesim2.Sint, 'Marker', '.')
xlabel('time');
title(['receptor gain: 60, R^2: ' num2str(samplesim2.error.R2)])
ylabel('$$\hat{s}$$', 'Interpreter', 'latex')

n = .06;
for jj = 1:length(D)
    if contains(D(jj).name, 'results')
        data = load(D(jj).name);
        subplot(2, 2, [3 4])
        hold on
        plot(data.data.spiketimes, data.error.Residuals.^2, 'Color', [0 0 .5] + [1 1 .5]*n)
        n = n + .06;
    end
end
xlabel('time'); ylabel('% error')
sgtitle('Forward Euler')