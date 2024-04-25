function error = computeError(spiketimes, t, F, Sint, kexc)

Fstand = F - F(1); % standardize by removing baseline force
tshift = t(find(Fstand > 0.01, 1, 'first')); % set the time when stretch starts to be 0
stshift = tshift; % shift spiketimes

Fs = interp1(t - tshift, Fstand, spiketimes - stshift);

S_scaled = Sint*4/kexc; % scaling factor found in the testExcValue script


error.Residuals = 
% error.Residuals = res;
% error.PercentError = pe;
% error.SSE = sse;
% error.R2 = r2;
% error.RMSE = rmse;