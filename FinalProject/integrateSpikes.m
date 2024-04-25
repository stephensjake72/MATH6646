function Sint = integrateSpikes(spiketimes, ifr, alpha, method)

ht = diff(spiketimes); 
yp = ifr;
switch method
    case 'FE'
        dy = @(h, y) h*y;
        Sint = zeros(size(spiketimes));

        for ii = 2:numel(spiketimes)
            Sint(ii) = Sint(ii-1) + dy(ht(ii-1), yp(ii-1));
        end
    case 'Trap'
        dy = @(h, y1, y2) 0.5*h*(y1 + y2);
        Sint = zeros(size(spiketimes));

        for ii = 2:numel(spiketimes)
            Sint(ii) = Sint(ii-1) + dy(ht(ii-1), yp(ii-1), yp(ii));
        end
end