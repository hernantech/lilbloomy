function twitobj = Grabtwitdata(config)
%Creates a twitter object using twitter for devs account credentials(in a struct named 'config')
%   I'm lazy as fuck so I won't even worry about encryption, shit's in
%   plaintext lmao 
consumerkey = config.twit.consumerkey;
consumersecret = config.twit.consumersecret;
accesstoken = config.twit.accesstoken;
accesstokensecret = config.twit.accesstoksecret;
twitobj = twitter(consumerkey,consumersecret,accesstoken,accesstokensecret);
end

