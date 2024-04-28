clc
clear

% [file, path] = uigetfile('/Volumes/labs/ting/shared_ting/Jake', '-mat')
path = '/Volumes/labs/ting/shared_ting/Jake/Multi_aff_sweeps/recdata/';
file = 'A100142-24-47_cell_13_II_96s.mat';
load([path file])
%%
t = recdata.time;
% F = recdata.Fmt;

n = 2; fs = 1/diff(t(1:2));
fcut = 100;
Wn = 2*fcut/fs;

[b, a] = butter(n, Wn, 'low');
F = filtfilt(b, a, recdata.Fmt);
dF = diff(F)./diff(t);
% sampledata.dF = diff(sampledata.F)./diff(sampledata.t);
% sampledata.dF = 
subplot(211)
plot(t, F)
subplot(212)
plot(t(1:end-1), dF)

keep = t > .73 & t < .9;
plot(t(keep), F(keep))
yyaxis right
plot(t(keep), dF(keep))


sampledata.t = t(keep);
sampledata.F = F(keep);
sampledata.dF = dF(keep);

save('sampledata.mat', 'sampledata')

%% this section is for some post-processing because I forgot to shift the start time
load('sampledata.mat')
tstart = sampledata.t(find(sampledata.F - sampledata.F(1) > .01, 1, 'first'));
plot(sampledata.t - tstart, sampledata.F - sampledata.F(1))
sampledata.t = sampledata.t - tstart;
save('sampledata.mat', 'sampledata')
