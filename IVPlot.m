function [h1, h2, h3, h4] = IVPlot(vol_in)
%Takes in a 4dim struct 'volatility' defined as (exp, strike, IVol)

h1 = squeeze(vol_in(1,:,:));
h2 = squeeze(vol_in(2,:,:));
h3 = squeeze(vol_in(3,:,:));
h4 = squeeze(vol_in(4,:,:));

end