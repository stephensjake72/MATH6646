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

%% Figure 3, example accuracy
samplesim1_FE = load('results_FE_kRec010_Noise1.mat');
samplesim2_FE = load('results_FE_kRec060_Noise1.mat');
samplesim1_AB2 = load('results_AB2__kRec010_Noise1.mat');
samplesim2_AB2 = load('results_AB2__kRec060_Noise1.mat');
samplesim1_AB3 = load('results_AB3__kRec010_Noise1.mat');
samplesim2_AB3 = load('results_AB3__kRec060_Noise1.mat');   

figure
subplot(2,3,1)
plot(sampledata.t, sampledata.F)
xlabel('time'); ylabel('s');
yyaxis right
plot(samplesim1_FE.data.spiketimes, samplesim1_FE.Sint, 'Marker', '.')
title(['FE, gain: 10, R^2: ' num2str(samplesim1_FE.error.R2)])
legend({'s', '$$\hat{s}$$'}, 'Interpreter', 'latex')

subplot(2,3,2)
plot(sampledata.t, sampledata.F)
yyaxis right
plot(samplesim1_AB2.data.spiketimes, samplesim1_AB2.Sint, 'Marker', '.')
xlabel('time');
title(['AB2, gain: 10, R^2: ' num2str(samplesim1_AB2.error.R2)])
ylabel('$$\hat{s}$$', 'Interpreter', 'latex')

subplot(2,3,3)
plot(sampledata.t, sampledata.F)
yyaxis right
plot(samplesim1_AB3.data.spiketimes, samplesim1_AB3.Sint, 'Marker', '.')
xlabel('time');
title(['AB3, gain: 10, R^2: ' num2str(samplesim1_AB3.error.R2)])
ylabel('$$\hat{s}$$', 'Interpreter', 'latex')

subplot(2,3,4)
plot(sampledata.t, sampledata.F)
yyaxis right
plot(samplesim2_FE.data.spiketimes, samplesim2_FE.Sint, 'Marker', '.')
xlabel('time');
title(['FE, gain: 60, R^2: ' num2str(samplesim2_FE.error.R2)])
ylabel('$$\hat{s}$$', 'Interpreter', 'latex')

subplot(2,3,5)
plot(sampledata.t, sampledata.F)
yyaxis right
plot(samplesim2_AB2.data.spiketimes, samplesim2_AB2.Sint, 'Marker', '.')
xlabel('time');
title(['AB2, gain: 60, R^2: ' num2str(samplesim2_AB2.error.R2)])
ylabel('$$\hat{s}$$', 'Interpreter', 'latex')

subplot(2,3,6)
plot(sampledata.t, sampledata.F)
yyaxis right
plot(samplesim2_AB3.data.spiketimes, samplesim2_AB3.Sint, 'Marker', '.')
xlabel('time');
title(['AB3, gain: 60, R^2: ' num2str(samplesim2_AB3.error.R2)])
ylabel('$$\hat{s}$$', 'Interpreter', 'latex')

sgtitle('Comparison of Integration Methods')

%% 
load('sampledata.mat')
methods = {'FE', 'Trap', 'AB2', 'AB3'};
receptor_gains = [10, 60]; 

r2_values = zeros(length(methods), length(receptor_gains));
rmse_values = zeros(length(methods), length(receptor_gains));
sse_values = zeros(length(methods), length(receptor_gains));

% Iterate over methods and receptor gains
for i = 1:length(methods)
    for j = 1:length(receptor_gains)
        method = methods{i};
        gain = receptor_gains(j);
        
        filename = sprintf('results_%s__kRec%03d_Noise1.mat', method, gain);
        data = load(filename);
        
        % Extract the error metrics
        r2_values(i, j) = data.error.R2;
        rmse_values(i, j) = data.error.RMSE;
        sse_values(i, j) = data.error.SSE;
    end
end

% Create the figure
figure;

subplot(1, 3, 1);
bar(r2_values);
xticklabels(methods);
ylabel('R^2');
title('R^2 Comparison');
legend(arrayfun(@(x) sprintf('Gain %d', x), receptor_gains, 'UniformOutput', false));

% RMSE subplot
subplot(1, 3, 2);
bar(rmse_values);
xticklabels(methods);
ylabel('RMSE');
title('RMSE Comparison');
legend(arrayfun(@(x) sprintf('Gain %d', x), receptor_gains, 'UniformOutput', false));

% SSE subplot
subplot(1, 3, 3);
bar(sse_values);
xticklabels(methods);
ylabel('SSE');
title('SSE Comparison');
legend(arrayfun(@(x) sprintf('Gain %d', x), receptor_gains, 'UniformOutput', false));

% Adjus
set(gcf, 'Position', [100, 100, 1200, 400]);
suptitle('Error Comparison Across Integration Methods and Receptor Gains');



