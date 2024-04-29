%% fig 4

clc; clear; close all;
load('sampledata.mat')

%%
D = dir();

colors1 = interp1([0 6], [199 233 192; 0 68 27], [0:6])/255
colors2 = interp1([0 6], [188 189 220; 63 0 125], [0:6])/255
colors3 = interp1([0 6], [252 146 114; 103 0 13], [0:6])/255

exccell = {'100', '150', '200', '250', '300', '350', '400'};

FElag = zeros(1, 7);
FER2 = zeros(1, 7);
AB2lag = zeros(1, 7);
AB2R2 = zeros(1, 7);
AB3lag = zeros(1, 7);
AB3R2 = zeros(1, 7);

count = [1 1 1];

for ii = 1:numel(D)
    if contains(D(ii).name, 'FE')
        expdata = load(D(ii).name);

        FER2(count(1)) = expdata.error.R2;
        FElag(count(1)) = expdata.error.lag;

        count(1) = count(1) + 1;
    elseif contains(D(ii).name, 'AB2')
        expdata = load(D(ii).name);

        AB2R2(count(2)) = expdata.error.R2;
        AB2lag(count(2)) = expdata.error.lag;

        count(2) = count(2) + 1;

    elseif contains(D(ii).name, 'AB3')
        expdata = load(D(ii).name);

        AB3R2(count(3)) = expdata.error.R2;
        AB3lag(count(3)) = expdata.error.lag;

        count(3) = count(3) + 1;
    else
        continue
    end
end

subplot(121)
plot(FElag, FER2, ...
    'Marker', 'o', ...
    'MarkerSize', 8, ...
    'Color', colors1(4, :))
hold on
scatter(FElag, FER2, 36, colors1, 'filled')
hold on
plot(AB2lag, AB2R2, ...
    'Marker', 'o', ...
    'MarkerSize', 8, ...
    'Color', colors2(4, :))
hold on
scatter(AB2lag, AB2R2, 36, colors2, 'filled')
hold on
plot(AB3lag, AB3R2, ...
    'Marker', 'o', ...
    'MarkerSize', 8, ...
    'Color', colors3(4, :))
hold on
scatter(AB3lag, AB3R2, 36, colors3, 'filled')

xlabel('lag (s)')
ylabel('R^2')
sgtitle('Accuracy vs integration delay')

subplot(122)
plot(FElag, FER2, ...
    'Marker', 'o', ...
    'MarkerSize', 8, ...
    'Color', colors1(4, :))
hold on
scatter(FElag, FER2, 36, colors1, 'filled')
hold on
plot(AB2lag, AB2R2, ...
    'Marker', 'o', ...
    'MarkerSize', 8, ...
    'Color', colors2(4, :))
hold on
scatter(AB2lag, AB2R2, 36, colors2, 'filled')
hold on
plot(AB3lag, AB3R2, ...
    'Marker', 'o', ...
    'MarkerSize', 8, ...
    'Color', colors3(4, :))
hold on
scatter(AB3lag, AB3R2, 36, colors3, 'filled')
xlim([0 .01])

xlabel('lag (s)')
ylabel('R^2')

print(['/Users/jacobstephens/Documents/FP_maccvslag'], '-depsc2')