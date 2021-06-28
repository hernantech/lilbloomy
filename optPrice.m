%function spits out array consisting of strikes, call prices, put prices,
%(in that order) based on available tickers for a particular  exp
function putarray = optPrice(data)
%Outputs [strike, putValue, callValue]
%killing the output 'callarray'

        %one gamma function per date, pulling gamma from each strike
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
    %dota(ii,2) = extractfield(data.optionChain.result.options.calls{ii}, 'openInterest');
    
    %dividend data for 
    %divyld = extractfield(data.optionChain.result.quote, 'trailingAnnualDividendYield');
    callarray(ii,1) = strike;
    [a,b] = blsprice(spot, strike, 0.015, dte, volatility);
    callarray(ii,2) = a;
    callarray(ii,3) = b;
    %array(ii,3) = blsprice(     )
end
for ii  = 1:size(data.optionChain.result.options.puts,1)

    strike = extractfield(data.optionChain.result.options.puts{ii}, 'strike');    
    %dota(ii,2) = extractfield(data.optionChain.result.options.calls{ii}, 'openInterest');
    
    %dividend data for 
    %divyld = extractfield(data.optionChain.result.quote, 'trailingAnnualDividendYield');
    putarray(ii,1) = strike;
    [a,b] = blsprice(spot, strike, 0.015, dte, volatility);
    putarray(ii,2) = b;
    putarray(ii,3) = a;
    %array(ii,3) = blsprice(     )
end
        
end
