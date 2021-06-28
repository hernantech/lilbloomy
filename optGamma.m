

%will change optgamma function to calculate/output an array of price and greeks 
%output [price, array, delta, vega, theta]
function array = optGamma(data)
%Such a pain in the ass trying to pull out the correct data         
        %as it's basically a fucking struct containing a cell containing a struct like tf
        %one gamma function per date, pulling gamma from each strike
dota = [];
array = [];
spot = (extractfield(data.optionChain.result.quote, 'bid') + extractfield(data.optionChain.result.quote, 'ask'))/2;
contract = char(extractfield(data.optionChain.result.options.calls{1}, 'contractSymbol'));
symbol = char(extractfield(data.optionChain.result, 'underlyingSymbol'));
expday = extractBetween(contract, length(symbol)+1, (length(symbol)+6));
dte = daysact(today, datetime(expday, 'InputFormat', 'yyMMdd'))/365;

%calculating a weighted volatility, since there's naturaly some vol skew
%which will affect the calculation, i.e. if we're above a certain price
%range, odds are that there'll be some downside skew, so for volatility
%we'll be using a weighted standard deviation:
stdtable = getMarketDataViaYahoo(symbol); % gets table of daily data YTD
volatility = sqrt(var(stdtable.AdjClose, stdtable.Volume));

for ii  = 1:size(data.optionChain.result.options.calls,1)
    
    strike = extractfield(data.optionChain.result.options.calls{ii}, 'strike');
    dota (ii,1) = strike;
    
    %dota(ii,2) = extractfield(data.optionChain.result.options.calls{ii}, 'openInterest');
    
    %dividend data for 
    %divyld = extractfield(data.optionChain.result.quote, 'trailingAnnualDividendYield');
    array(ii,1) = strike;
    array(ii,2) = 100*blsgamma(spot, strike, 0.0151, dte, volatility);
    %array(ii,3) = blsprice(     )
end
        
end
