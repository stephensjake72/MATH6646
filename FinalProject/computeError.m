function error = computeError(spiketimes, t, F, Sint)
% tshift = spiketimes(2) - spiketimes(1);
Fs = interp1(t, F, spiketimes);

lm = fitlm(Fs, Sint);
res = lm.Residuals.Raw;
pe = abs(res./Fs);
sse = sum(res.^2);
r2 = lm.Rsquared.Adjusted;
rmse = lm.RMSE;

error.Residuals = res;
error.PercentError = pe;
error.SSE = sse;
error.R2 = r2;
error.RMSE = rmse;