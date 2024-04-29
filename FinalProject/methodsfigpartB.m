%% methods fig part B

clc; clear; close all;

load('sampledata.mat')

%%

D = dir()

startcolor =  [200, 200, 200];
endcolor = [0, 0, 0];
colors1 = interp1([0 6], [startcolor; endcolor], [0:6])
colors1 = colors1/255;

ccount = 1;
for ii = 1:numel(D)
    if ~contains(D(ii).name, 'spikeTrain')
        continue
    end
    data = load(D(ii).name);
    
    hold on
    plot(data.spiketimes, data.ifr, 'Marker', '.', 'LineStyle', 'none', ...
        'Color', colors1(ccount, :))
    ccount = ccount + 1;
end
legend({'100', '150', '200', '250', '300', '350', '400'}, 'Location','northwest')
xlabel('time')
ylabel('R_n')

print(['/Users/jacobstephens/Documents/FP_spikeratesvkexc'], '-depsc2')