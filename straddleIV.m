function [outputArg1,outputArg2] = straddleIV(poopdata, h1, h2, h3, h4)
%function grabs the spot price and the indices for the spot from 
%   Detailed explanation goes here
 

strikes_prices = evalOptData(poopdata, 'calls', 'lastPrice'); 
spot = (extractfield(poopdata.optionChain.result.quote, 'bid') + extractfield(poopdata.optionChain.result.quote, 'ask'))/2;
spot = floor(spot);
index_spot_strike = find(strikes_prices(:,1)==spot1);

outputArg1 = inputArg1;
outputArg2 = inputArg2;
end

