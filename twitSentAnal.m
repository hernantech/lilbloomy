function [tweetstruct,outputArg2] = twitSentAnal(config,tickerstring, numtweets)
%twitSentAnal requires a config struct with twit for dev credentials, a
%ticker to search for, and a number of tweets to analyze
%   Detailed explanation goes here...or does it?

twitobj = Grabtwitdata(config);
parameters.count = numtweets;
tweetstruct = search(twitobj, tickerstring, parameters);
end

