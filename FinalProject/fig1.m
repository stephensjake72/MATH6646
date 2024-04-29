%% fig 1

clc; clear; close all;
load('sampledata.mat')
load('results_FE__kRec200_Noise1.mat')

%%
subplot(221)
plot(sampledata.t, sampledata.F)
ax = gca;
xlabel('time')
ylabel('s(t)')
title('Original Signal')

subplot(222)
plot(data.spiketimes, data.ifr, '.k')
xlim(ax.XAxis.Limits)
title('Neural Signal')


subplot(223)
plot(data.spiketimes, Sint)
ylim([0 25])
yyaxis right
plot(sampledata.t, sampledata.F)
ylim([sampledata.F(1) sampledata.F(1)+3])
xlim(ax.XAxis.Limits)
legend({'$\hat{s}$', 's'}, 'Interpreter', 'latex')
title('Integrated Approximation')

subplot(224)
plot(error.t, error.sqresid)
xlim(ax.XAxis.Limits)
xlabel('time')
ylabel('square resid.')
title('Approximation Error')

print(['/Users/jacobstephens/Documents/FP_FEexamplefig'], '-depsc2')