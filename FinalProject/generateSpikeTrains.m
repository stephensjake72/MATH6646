% setup
clc; clear; close all

load('sampledata.mat')

%%
% data parameters
t = sampledata.t;
dt = diff(t(1:2));

% neuron model
C = 1; % capacitance
R = 2500; % resistance
V_depol = 60; % depolarization voltage
V_hyperpol = -75; % hyperpolarization voltage
spikethr = -50; % spike threshold potential
V_rest = -65; % resting potential
Vm = zeros(size(t));
Vm(1) = V_rest;

dV = @(I, V) (1/C)*(I - (V - V_rest)/R); % differential eq for Vmembrane

% stimulus parameters
kexc = 400; % receptor current scaling factor 
Irec = kexc*sampledata.dF; % receptor current
It = Irec; % total current into the neuron

figure('Position', [0 500 500 500])
subplot(211)
plot(t, sampledata.F)
xlim([min(t) max(t)])
ax = gca;
subplot(212)
plot(t, sampledata.dF)
xlim(ax.XAxis.Limits)
xlabel('time')

if kexc == 200
    print(['/Users/jacobstephens/Documents/FPfig1A'], '-depsc2')
end
% stimulus noise
knoise = 1;


for  ii = 2:numel(t)
    if Vm(ii - 1) >= spikethr && Vm(ii - 1) < V_depol
        Vm(ii) = V_depol;
    elseif Vm(ii - 1) >= V_depol
        Vm(ii) = V_hyperpol;
    else
        Vm(ii) = Vm(ii - 1) + dV(It(ii), Vm(ii))*dt;
    end
end

spiketimes = t(Vm == V_depol);
ifr = [1./(spiketimes(2:end)-spiketimes(1:end-1)); 0];

figure('Position', [500 500 500 500])
subplot(211)
plot(t, Vm)
xlim(ax.XAxis.Limits)
subplot(212)
plot(spiketimes, ifr, '.k')
xlim(ax.XAxis.Limits)

if kexc == 200
    print(['/Users/jacobstephens/Documents/FPfig1B'], '-depsc2')
end

recstr = sprintf('%g', kexc);
filename = ['spikeTrain_kRec' recstr '_Noise' num2str(knoise)];
save(filename, 't', 'Vm', 'spiketimes', 'ifr', 'Irec', 'It')