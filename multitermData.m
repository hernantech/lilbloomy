function Volatility = multitermData(ticker)
%purpose of this function is to run yahoptdata on several expirations so
%that I can build the term structure or an IV surface

a(1) = datetime('2021-07-16');
a(2) = datetime('2021-09-17');
a(3) = datetime('2021-08-20');
a(4) = datetime('2021-11-19');

for i = 1:length(a)
    try
        optdata(i) = YahOptData(ticker, a(i));
    catch e %e is an MException struct
        fprintf(1,'The identifier was:\n%s',e.identifier);
        fprintf(1,'There was an error! The message was:\n%s',e.message);
    end
end
%note that the below backsolves for THEORETICAL IVol of the stock
disp(length(optdata))
%%this means I have to pull each one(of which there are usually over a 100) and then backsolve each one of
%%those to get volatility
spot_price = (extractfield(optdata(1).optionChain.result.quote, 'bid') + extractfield(optdata(1).optionChain.result.quote, 'ask'))/2;
if spot_price==0
    spot_price = extractfield(optdata(1).optionChain.result.quote, 'regularMarketPreviousClose');
end
%spot_price = 420;
for k = 1:length(optdata)
    %fuck the strikes aren't the same across all data, need to do it
    %dynamically
    strikes_prices = evalOptData(optdata(k), 'calls', 'lastPrice'); 
    spot1 = floor(spot_price);
    index_spot_strike = find(strikes_prices(:,1)==spot1)
    if isempty(index_spot_strike)
    [~,idx] = min(abs(strikes_prices - spot1));
    %[~,~,idx]=unique(round(abs(strikes_prices-spot1)),'stable');
    index_spot_strike = idx(1);
    %minVal = a(idx==1);
    end
    ind1 = index_spot_strike-10;
    ind2 = index_spot_strike+10;
    netind = ind2-ind1;
    jj = ind1-1;
    % pay attention to the indices above I've lost track and they might
    % return bugs in really fringe cases like small liq tickers
    % i.e. small caps
    
    %note that evaloptdata returns a nx2 array with the strike and lastprice
    for ii = 1:netind
        jj = jj+1;
        Volatility(k,ii,1) = strikes_prices(jj,1);
        Volatility(k,ii,2) = blsimpv(spot_price, strikes_prices(jj,1), 0.015, (daysact(today, datetime(a(i), 'InputFormat', 'yyMMdd'))/365), strikes_prices(jj,2));
        Volatility(k,ii,3) = blsimpv(spot_price, strikes_prices(jj,1), 0.015, (daysact(today, datetime(a(i), 'InputFormat', 'yyMMdd'))/365), strikes_prices(jj,2), 'Class', {'put'});
    end
    %great Black-scholes breaks down when touching deep ITM options, 
    %SMH Will have to limit output to somewhere /pm half of
    %whatever the spot price is, so if spot is trading at 130 then lower
    %lim for strikes is 65, upper lim is 180;
    %alternatively could do what TDA does and limit it to 14 strikes, 7
    %above, 7 below, etc.
end

end


