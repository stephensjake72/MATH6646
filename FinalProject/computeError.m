function error = computeError(spiketimes, t, F, Sint, method)

Fstand = F - F(1); % standardize by removing baseline force

switch method % align signals at time 0
    case 'FE' 
        stshift = spiketimes(1);
    case 'AB2'
        stshift = spiketimes(2);
    case 'AB3'
        stshift = spiketimes(3);
end

% time shift spike times to start signal at t = 0
shiftedtimes = spiketimes - stshift;

% create time window
twin = t > shiftedtimes(1) & t < shiftedtimes(end);

Sinterp = interp1(shiftedtimes, Sint, t(twin), 'linear'); % resample integrated signal at normal time

Fref = Fstand(twin);

lm = fitlm(Sinterp, Fref);


% Compute error metrics
error.lag = stshift;
error.resid = lm.Residuals.Raw;
error.sqresid = error.resid.^2;
error.SSE = lm.SSE;
error.R2 = lm.Rsquared.Ordinary;
error.s_hat = Sinterp;
error.s_ref = Fref;
error.t = t(twin);
end