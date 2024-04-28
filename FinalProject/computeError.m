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

% scale the integrated signal as per findings from the testExcValue script
S_scaled = Sinterp*length(Sint)/2.5;

F = F(twin);


% Compute error metrics
error.lag = stshift;
error.resid = F - S_scaled;
error.sqresid = (F - S_scaled).^2;
error.SSE = sum(error.sqresid);
end