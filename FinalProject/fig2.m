%% fig 2

clc; clear; close all;

load('sampledata.mat')

%%

D = dir();

startcolor =  [199, 233, 192];
endcolor = [0, 68, 27];
colors1 = interp1([0 6], [startcolor; endcolor], [0:6])
colors1 = colors1/255;

colors2 = interp1([0 6], [.5 .5 .5; 0 0 0], [0:6])
subplot(221)
plot(sampledata.t, sampledata.F)
ylabel('$s$', 'Interpreter','latex')
ax = gca;
title('Original Signal')

ccount = 1;
for ii = 1:numel(D)
    if ~contains(D(ii).name, 'FE')
        continue
    end
    expdata = load(D(ii).name);

    subplot(223)
    hold on
    plot(expdata.data.spiketimes, expdata.Sint, 'Color', colors1(ccount, :))
    xlim(ax.XAxis.Limits)
    xlabel('time')
    ylabel('$\hat{s}$', 'Interpreter','latex')
    title('Forward Euler integrated signals')

    subplot(222)
    hold on
    plot(expdata.error.t, expdata.error.sqresid, 'Color', colors1(ccount, :))
    xlim(ax.XAxis.Limits)
    xlabel('time')
    ylabel('squared resid.')
    title('Error')

    f = find(D(ii).name == '_');
    excstr = D(ii).name(f(3)+5:f(4)-1);
    exc = str2num(excstr)
    expdata.error.R2

    subplot(224)
    hold on
    scatter(exc, expdata.error.R2, 56, colors1(ccount, :), "filled")
    xlim([0 500])
    ylim([.997 1])
    xlabel('k_{exc}')
    ylabel('R^2')
    title('Accuracy')

    ccount = ccount+1;

end
subplot(223)
legend({'100', '150', '200', '250', '300', '350', '400'})

print(['/Users/jacobstephens/Documents/FP_FEresultsfig'], '-depsc2')