%% fig3

clc; clear; close all;
load('sampledata.mat')

%%
D = dir();

figure('Position', [0 0 1000 500])

% plot original stimulus as reference
subplot(2, 5, [1, 6])
plot(sampledata.t, sampledata.F)
ax = gca;

% create color palettes
colors1 = interp1([0 6], [199 233 192; 0 68 27], [0:6])/255
colors2 = interp1([0 6], [188 189 220; 63 0 125], [0:6])/255
colors3 = interp1([0 6], [252 146 114; 103 0 13], [0:6])/255

% create counter vector
ccount = [1 1 1];

for ii = 1:numel(D)
    if contains(D(ii).name, 'FE')
        expdata = load(D(ii).name);

        % plot estimated stimulus
        subplot(2, 5, 2)
        hold on
        plot(expdata.data.spiketimes, expdata.Sint, ...
            'Color', colors1(ccount(1), :))
        xlim(ax.XAxis.Limits)
        title('Forward Euler')

        % plot error over time
        subplot(2, 5, 7)
        hold on
        plot(expdata.error.t, expdata.error.sqresid, ...
            'Color', colors1(ccount(1), :))
        xlim(ax.XAxis.Limits)

        % pull excitability from file name
        f = find(D(ii).name == '_');
        excstr = D(ii).name(f(3)+5:f(4)-1);
        exc = str2num(excstr);
        
        % plot accuracy vs excitability
        subplot(2, 5, [5 10])
        hold on
        scatter(exc, expdata.error.R2, 32, colors1(ccount(1), :), "filled")
        xlim([0 500])

        ccount(1) = ccount(1) + 1;
    elseif contains(D(ii).name, 'AB2')
        % use same process for other methods
        expdata = load(D(ii).name);
        subplot(2, 5, 3)
        hold on
        plot(expdata.data.spiketimes, expdata.Sint, ...
            'Color', colors2(ccount(2), :))
        xlim(ax.XAxis.Limits)
        title('AB2')

        subplot(2, 5, 8)
        hold on
        plot(expdata.error.t, expdata.error.sqresid, ...
            'Color', colors2(ccount(2), :))
        xlim(ax.XAxis.Limits)

        subplot(2, 5, [5 10])

        f = find(D(ii).name == '_');
        excstr = D(ii).name(f(3)+5:f(4)-1);
        exc = str2num(excstr);
    
        hold on
        scatter(exc, expdata.error.R2, 32, colors2(ccount(2), :), "filled")
        xlim([0 500])
        ccount(2) = ccount(2) + 1;
    elseif contains(D(ii).name, 'AB3')
        expdata = load(D(ii).name);
        subplot(2, 5, 4)
        hold on
        plot(expdata.data.spiketimes, expdata.Sint, ...
            'Color', colors3(ccount(3), :))
        xlim(ax.XAxis.Limits)
        title('AB3')

        subplot(2, 5, 9)
        hold on
        plot(expdata.error.t, expdata.error.sqresid, ...
            'Color', colors3(ccount(3), :))
        xlim(ax.XAxis.Limits)

        subplot(2, 5, [5 10])

        f = find(D(ii).name == '_');
        excstr = D(ii).name(f(3)+5:f(4)-1);
        exc = str2num(excstr);
    
        hold on
        scatter(exc, expdata.error.R2, 32, colors3(ccount(3), :), "filled")
        xlim([0 500])

        ccount(3) = ccount(3) + 1;
    else
        continue
    end
end

% set labels
subplot(2, 5, [1 6])
xlabel('time')
ylabel('s')
title('Original Signal')

subplot(2, 5, 2)
ylabel('$\hat{s}$', 'Interpreter','latex')

subplot(2, 5, 7)
xlabel('time')
ylabel('squared resid.')

subplot(2, 5, 8)
xlabel('time')
subplot(2, 5, 9)
xlabel('time')

subplot(2, 5, [5 10])
xlabel('k_{exc}')
ylabel('R^2')
title('Model Accuracy')


% export vector graphics file
print(['/Users/jacobstephens/Documents/FP_modelresultsfig'], '-depsc2')