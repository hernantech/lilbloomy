function data = YahOptData(symbol, exp)
    % Downloads market data from Yahoo Finance for a specified symbol and 
    % time range.
    % 
    %
    
    if(nargin() == 1)
        %note that if retreiving options data then start and end times are
        %trivial
        exp = posixtime(datetime('2021-09-17'));
    elseif (nargin() == 2)
        exp = posixtime(datetime(exp));
    else
        error('At least one parameter is required. Specify ticker symbol.');
        data = [];
        return;
    end
    
    % Send a request for data
    % Construct an URL for the specific data
    %https://query1.finance.yahoo.com/v7/finance/options/NFLX is a sample
    %URL for options
    uri = matlab.net.URI(['https://query1.finance.yahoo.com/v7/finance/options/', upper(symbol)], ...
        'date',  num2str(int64(exp), '%.10g'));...
        %disp(uri)   
        %'period2',  num2str(int64(enddate), '%.10g'),...
        %'interval', interval,...
        %'events',   'history',...
        %'frequency', interval,...
        %'guccounter', 1,...
        %'includeAdjustedClose', 'true');  
    options = weboptions('ContentType','json', 'UserAgent', 'Chrome/72.0');
    try
        data = webread(uri.EncodedURI, options);
        
    catch ME
        data = [];
        warning(['Identifier: ', ME.identifier, 'Message: ', ME.message])
    end 
disp(symbol)
end
