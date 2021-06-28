function array = GammaEx(data)
call_array = data2_40OI(data, 'calls');
put_array = data2_40OI(data, 'puts');
%call-put parity implies that we'll have equal gamma for both ends of the
%trade, so we only need to pull up call data

spot_price = (extractfield(data(1).optionChain.result.quote, 'bid') + extractfield(data(1).optionChain.result.quote, 'ask'))/2;
if spot_price==0
    spot_price = extractfield(data.optionChain.result.quote, 'regularMarketPreviousClose');
end
contract = char(extractfield(data.optionChain.result.options.calls{1}, 'contractSymbol'));
symbol = char(extractfield(data.optionChain.result, 'underlyingSymbol'));
expday = extractBetween(contract, length(symbol)+1, (length(symbol)+6));
dte = daysact(today, datetime(expday, 'InputFormat', 'yyMMdd'))/365;

stdtable = getMarketDataViaYahoo(symbol); % gets table of daily data YTD
volatility = 0.01*sqrt(var(stdtable.AdjClose, stdtable.Volume));

for i = 1:length(call_array)
    gamm(i) = blsgamma(spot_price,call_array(i,1),0.0151,dte,volatility);
    array(i,1) = call_array(i,1);%strikes
    array(i,2) = gamm(i)*(call_array(i,2)-put_array(i,2));%net
    array(i,3) = gamm(i)*call_array(i,2);%calls
    array(i,4) = gamm(i)*put_array(i,2);%puts
end

end