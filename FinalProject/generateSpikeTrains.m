% setup
clc; clear; close all

load('sampledata.mat')

%%
% data parameters
t = sampledata.t;
dt = diff(t(1:2));

% neuron model (these parameters are all relatively arbitrary and selected 
% based on the spiking frequency generated at different currents)
C = 1; % capacitance
R = 2500; % resistance
V_depol = 60; % depolarization voltage (not arbitrary)
V_hyperpol = -75; % hyperpolarization voltage (not arbitrary)
spikethr = -50; % spike threshold potential (not arbitrary)
V_rest = -65; % resting potential (not arbitrary)

% create membrane voltage vector
Vm = zeros(size(t));
Vm(1) = V_rest; % initially at rest

dV = @(I, V) (1/C)*(I - (V - V_rest)/R); % differential eq for Vmembrane

% stimulus parameters
kexc = 400; % receptor current scaling factor 
Irec = kexc*sampledata.dF; % receptor current
It = Irec; % total current into the neuron

% plot sample data
figure('Position', [0 500 500 500])
subplot(211)
plot(t, sampledata.F)
xlim([min(t) max(t)])
ax = gca;
subplot(212)
plot(t, sampledata.dF)
xlim(ax.XAxis.Limits)
xlabel('time')

% save example sim
if kexc == 200
    print(['/Users/jacobstephens/Documents/FPfig1A'], '-depsc2')
end
% stimulus noise (not used in final version)
knoise = 1;

% solve for Vm with forward Euler
for  ii = 2:numel(t)
    % generate spike if over threshold
    if Vm(ii - 1) >= spikethr && Vm(ii - 1) < V_depol
        Vm(ii) = V_depol;
    % hyperpolarize after spike
    elseif Vm(ii - 1) >= V_depol
        Vm(ii) = V_hyperpol;
    % integrate if not depolarized
    else
        Vm(ii) = Vm(ii - 1) + dV(It(ii), Vm(ii))*dt;
    end
end

% extract spike timing data
spiketimes = t(Vm == V_depol);
ifr = [1./(spiketimes(2:end)-spiketimes(1:end-1)); 0];

% plot to check
figure('Position', [500 500 500 500])
subplot(211)
plot(t, Vm)
xlim(ax.XAxis.Limits)
subplot(212)
plot(spiketimes, ifr, '.k')
xlim(ax.XAxis.Limits)

% export example sim figure
if kexc == 200
    print(['/Users/jacobstephens/Documents/FPfig1B'], '-depsc2')
end

% create data save name and save data structures
recstr = sprintf('%g', kexc);
filename = ['spikeTrain_kRec' recstr '_Noise' num2str(knoise)];
save(filename, 't', 'Vm', 'spiketimes', 'ifr', 'Irec', 'It')