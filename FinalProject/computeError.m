function error = computeError(spiketimes, t, F, Sint)

Fstand = F - F(1); % standardize by removing baseline force
tshift = t(find(Fstand > 0.01, 1, 'first')); % set the time when stretch starts to be 0
stshift = tshift; % shift spiketimes

Fs = interp1(t - tshift, Fstand, spiketimes - stshift);

% Compute the scaling factor
kexc = max(Fs) / max(Sint);

S_scaled = Sint * kexc; % scale the integrated signal

% Compute error metrics
res = Fs - S_scaled;
pe = abs(res)./Fs * 100;
sse = sum(res.^2);
sst = sum((Fs - mean(Fs)).^2);
r2 = 1 - sse/sst;
rmse = sqrt(mean(res.^2));

error.Residuals = res;
error.PercentError = pe;
error.SSE = sse;
error.R2 = r2;
error.RMSE = rmse;
end