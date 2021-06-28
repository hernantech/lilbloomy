%function spits out array consisting of strikes, call prices, put prices,
%(in that order) based on available tickers for a particular  exp
function array = theoPrices(data)
%strike_array is from theovsprice
%killing the output 'callarray'
%Such a pain in the ass trying to pull out the correct data         
        %as it's basically a fucking struct containing a cell containing a struct like tf
        %one gamma function per date, pulling gamma from each strike
spot = (extractfield(data.optionChain.result.quote, 'bid') + extractfield(data.optionChain.result.quote, 'ask'))/2;
if spot==0
    spot = extractfield(data.optionChain.result.quote, 'regularMarketPreviousClose');
end
contract = char(extractfield(data.optionChain.result.options.calls{1}, 'contractSymbol'));
symbol = char(extractfield(data.optionChain.result, 'underlyingSymbol'));
expday = extractBetween(contract, length(symbol)+1, (length(symbol)+6));
dte = daysact(today, datetime(expday, 'InputFormat', 'yyMMdd'))/365;


call_array = theoVsprice(data, 'calls');
put_array = theoVsprice(data, 'puts');
%^^grabs 40 strikes from each around the spot price

%calculating a weighted volatility, since there's naturaly some vol skew
%which will affect the calculation, i.e. if we're above a certain price
%range, odds are that there'll be some downside skew, so for volatility
%we'll be using a weighted standard deviation:
stdtable = getMarketDataViaYahoo(symbol); % gets table of daily data YTD
volatility = 0.01*sqrt(var(stdtable.AdjClose, stdtable.Volume));

strike_start = call_array(1,1);
%num_strikes = lenght(strikes);

call_strike_array = evalOptData(data, 'calls', 'lastPrice');
put_strike_array = evalOptData(data, 'puts', 'lastPrice');
%^^grabs all price data for calls/puts

index_spot_strike_calls = find(call_strike_array(:,1)==strike_start);
index_spot_strike_puts = find(put_strike_array(:,1)==strike_start);

    for ii  = 1:length(call_array)
    
    %repetitive to extract the strikes again, ignore bottom
    %strike = extractfield(data.optionChain.result.options.calls{ii}, 'strike');    
    %dota(ii,2) = extractfield(data.optionChain.result.options.calls{ii}, 'openInterest');
    
    %dividend data for 
    %divyld = extractfield(data.optionChain.result.quote, 'trailingAnnualDividendYield');
    this_strike = call_strike_array(ii+index_spot_strike_calls,1);
    array(ii,1) = this_strike;
    [a,b] = blsprice(spot, this_strike, 0.015, dte, volatility);
    array(ii,2) = a - call_array(ii,2);
    %array(ii,2) = call_array(ii,2)-array(ii,2);
    array(ii,3) = b - put_array(ii,2);
    %array(ii,3) = call_array(ii,3)-array(ii,3);
    end
end
