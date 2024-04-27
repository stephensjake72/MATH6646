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
    case 'AB2' %AB-2
        dy = @(h, y1, y2) h*(1.5*y2 - 0.5*y1);
        Sint = zeros(size(spiketimes));
        Sint(1) = yp(1)*ht(1);

        for ii = 2:numel(spiketimes)-1
            Sint(ii+1) = Sint(ii) + dy(ht(ii), yp(ii-1), yp(ii));
        end
    case 'AB3' %AB-3
        dy = @(h, y1, y2, y3) h*(23/12*y3 - 4/3*y2 + 5/12*y1);
        Sint = zeros(size(spiketimes));
        Sint(1) = yp(1)*ht(1);
        Sint(2) = Sint(1) + ht(2)*(1.5*yp(2) - 0.5*yp(1));

        for ii = 3:numel(spiketimes)-1
            Sint(ii+1) = Sint(ii) + dy(ht(ii), yp(ii-2), yp(ii-1), yp(ii));
        end
end
      
end