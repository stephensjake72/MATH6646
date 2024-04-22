% setup
clc; clear; close all

load('sampledata.mat')

%%
% data parameters
t = sampledata.t;
dt = diff(t(1:2));

% neuron model
C = 2.5; % capacitance
R = 5000; % resistance
V_depol = 60; % depolarization voltage
V_hyperpol = -75; % hyperpolarization voltage
spikethr = -50; % spike threshold potential
V_rest = -65; % resting potential
Vm = zeros(size(t));
Vm(1) = V_rest;

dV = @(I, V) (1/C)*(I - (V - V_rest)/R); % differential eq for Vmembrane

% stimulus parameters
kexc = 0.0;
krec = .055; % receptor current scaling factor 
Irec = krec*sampledata.dF; % receptor current 
Iexc = kexc*ones(size(Irec));
It = Irec + Iexc; % total current into the neuron

figure('Position', [0 500 500 500])
plot(t, Irec)

% stimulus noise
knoise = 1;


for  ii = 2:numel(t)
    if Vm(ii - 1) >= spikethr && Vm(ii - 1) < V_depol
        Vm(ii) = V_depol;
    elseif Vm(ii - 1) >= V_depol
        Vm(ii) = V_hyperpol;
    else
        Vm(ii) = Vm(ii - 1) + dV(It(ii), Vm(ii));
    end
end

spiketimes = t(Vm == V_depol);
ifr = [1./(spiketimes(2:end)-spiketimes(1:end-1)); 0];

figure('Position', [500 500 500 500])
subplot(211)
plot(t, Vm)
ax = gca;
subplot(212)
plot(spiketimes, ifr, '.k')
xlim(ax.XAxis.Limits)

recstr = sprintf('%.3f', krec);
recstr = recstr(3:end);
filename = ['spikeTrain_kRec' recstr '_Noise' num2str(knoise)]
save(filename, 't', 'Vm', 'spiketimes', 'ifr', 'Irec', 'Iexc', 'It')