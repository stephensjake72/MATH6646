% computing the error presents the challenge of how to align the signals in
% time. 
clc
clear
close all

load('sampledata.mat')
D = dir();


for ii = 1:numel(D)
    if ~contains(D(ii).name, 'AB3')
        continue
    end
    expdata = load(D(ii).name);

    % stshift = 0;
    stshift = expdata.data.spiketimes(3);
    hold on
    plot(expdata.data.spiketimes - stshift, expdata.Sint)
end
yyaxis right
plot(sampledata.t, sampledata.F)

% testing shows subtracting the first spike time in FE, 2nd in AB2, and
% 3rd in AB3 aligns the all the signals at time 0.

%%
for ii = 1:numel(D)
    if ~contains(D(ii).name, 'AB3')
        continue
    end
    expdata = load(D(ii).name);

    st = expdata.data.spiketimes - expdata.data.spiketimes(3);
    
    twin = sampledata.t > st(1) & sampledata.t < st(end);

    Sinterp = interp1(st, expdata.Sint, sampledata.t(twin));

    % stwin = st > 0; % trim initial part
    % subplot(211)
    % hold on
    % plot(expdata.data.spiketimes, expdata.Sint)
    % subplot(212)
    % hold on
    % plot(st, expdata.Sint)
    
    figure
    subplot(211)
    plot(sampledata.t, sampledata.F)
    hold on
    plot(sampledata.t(twin), sampledata.F(twin))
    yyaxis right
    plot(sampledata.t(twin), Sinterp, '.k')


end
yyaxis right
plot(sampledata.t, sampledata.F)