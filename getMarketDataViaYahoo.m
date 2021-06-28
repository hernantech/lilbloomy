function data = getMarketDataViaYahoo(symbol, startdate, enddate, interval)
    % Downloads market data from Yahoo Finance for a specified symbol and 
    % time range.
    % 
    % INPUT:
    % symbol    - is a ticker symbol i.e. 'AMD', 'BTC-USD'
    % startdate - the date from which the market data will be requested
    % enddate   - the market data will be requested till this date
    % interval  - the market data will be returned in this intervals
    % supported intervals are '1d', '5d', '1wk', '1mo', '3mo'
    %
	% OUTPUT:
    % data - is a retrieved  dataset returned as a table
    %
    
    if(nargin() == 1)
        startdate = posixtime(datetime('1-Jan-2021'));
        enddate = posixtime(datetime()); % now
        interval = '1d';
    elseif (nargin() == 2)
        startdate = posixtime(datetime(startdate));
        enddate = posixtime(datetime()); % now
        interval = '1d';
    elseif (nargin() == 3)
        startdate = posixtime(datetime(startdate));
        enddate = posixtime(datetime(enddate));        
        interval = '1d';
    elseif(nargin() == 4)
        startdate = posixtime(datetime(startdate));
        enddate = posixtime(datetime(enddate));
    else
        error('At least one parameter is required. Specify ticker symbol.');
        data = [];
        return;
    end
    
    % Send a request for data
    % Construct an URL for the specific data
    %https://query1.finance.yahoo.com/v7/finance/options/NFLX is a sample
    %URL for options
    uri = matlab.net.URI(['https://query1.finance.yahoo.com/v7/finance/download/', upper(symbol)],...
        'period1',  num2str(int64(startdate), '%.10g'),...
        'period2',  num2str(int64(enddate), '%.10g'),...
        'interval', interval,...
        'events',   'history',...
        'frequency', interval,...
        'guccounter', 1,...
        'includeAdjustedClose', 'true');  
    
    options = weboptions('ContentType','table', 'UserAgent', 'Mozilla/5.0');
    try
        data = rmmissing(webread(uri.EncodedURI, options));
    catch ME
        data = [];
        warning(['Identifier: ', ME.identifier, 'Message: ', ME.message])
    end 
end
