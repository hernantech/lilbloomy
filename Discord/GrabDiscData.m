function outputArray = GrabDiscData(server_i)
%GRABDATA Grabs data from discord, 
%   Detailed explanation goes here
    % Downloads market data from Yahoo Finance for a specified symbol and 
    % time range.
    % 
    %
%     
%     if(nargin() == 1)
%         %note that if retreiving options data then start and end times are
%         %trivial
%         exp = posixtime(datetime('2021-09-17'));
%     elseif (nargin() == 2)
%         exp = posixtime(datetime(exp));
%     else
%         error('At least one parameter is required. Specify ticker symbol.');
%         data = [];
%         return;
%     end
    
    % Send a request for data
    % Construct an URL for the specific data
    %https://query1.finance.yahoo.com/v7/finance/options/NFLX is a sample
    %URL for options
    api_endpoint = 'https://discord.com/api/v9';
    redirect_uri = '';
        client_id = 'YOUR CLIENT ID FROM GOOGLE DEVELOPER CONSOLE';
        client_secret = 'YOUR CLIENT SECRET FROM GOOGLE DEVELOPER CONSOLE';
        url = 'https://accounts.google.com/o/oauth2/token';
        redirect_uri = 'urn:ietf:wg:oauth:2.0:oob';
        code = 'YOUR AUTHORIZATION CODE';
        data = [...
         'redirect_uri=', redirect_uri,... 
         '&client_id=', client_id,...
         '&client_secret=', client_secret,...
         '&grant_type=', 'authorization_code',...
         '&code=', code];
        response = webwrite(url,data);
        access_token = response.access_token;
        % save access token for future calls
        headerFields = {'Authorization', ['Bearer ', access_token]};
        options = weboptions('HeaderFields', headerFields, 'ContentType','json');
    try
        data = webread(uri.EncodedURI, options);
        
    catch ME
        data = [];
        warning(['Identifier: ', ME.identifier, 'Message: ', ME.message])
    end 
disp(symbol)

end

