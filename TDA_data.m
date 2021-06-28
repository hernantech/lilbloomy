function [outputArg1,outputArg2] = TDA_data(inputArg1,inputArg2)
%TDA_DATA Summary of this function goes here
%   Detailed explanation goes here


client_id = 'DQLVUAPW26AHWFDPB2BEYGGVSBXG3PSE';%'YOUR CLIENT ID ';
client_secret = 'client_secret_FILL';%'YOUR CLIENT SECRET ';
url = 'https://api.tdameritrade.com/v1/marketdata/chains';
username = 'hernantech';
password='99Problems';
scope = 'scope-FILL';
headerFields = {'Content-type' 'application/x-www-form-urlencoded';'charset' 'UTF-8'};
options = weboptions('HeaderFields', headerFields);
response = webwrite(url,...
'client_id', client_id,...
'client_secret', client_secret,...
'grant_type','password',...
'scope',scope,... 
'username',username,...
'password',password,...
options);

outputArg1 = inputArg1;
outputArg2 = inputArg2;
end

