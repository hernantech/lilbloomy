
function array = data2_40OI(data, calorputs)
% Takes in (data, calorputs), where data is the struct containing
% option data, calorputs is 'calls' or 'puts'

dota = [];

spot_price = (extractfield(data(1).optionChain.result.quote, 'bid') + extractfield(data(1).optionChain.result.quote, 'ask'))/2;
if spot_price==0
    spot_price = extractfield(data.optionChain.result.quote, 'regularMarketPreviousClose');
end
strikes_prices = evalOptData(data, 'puts', 'lastPrice'); 
spot1 = floor(spot_price);
%need to adjust for when strike is not equal to floor(spotprice)
index_spot_strike = find(strikes_prices(:,1)==spot1);
if isempty(index_spot_strike)
    [~,idx] = min(abs(strikes_prices - spot1));
    %[~,~,idx]=unique(round(abs(strikes_prices-spot1)),'stable');
    index_spot_strike = idx(1);
    %minVal = a(idx==1);
end

ind1 = index_spot_strike-20;
ind2 = index_spot_strike+20;
netind = ind2-ind1;
jj = ind1-1;
%putarray = optPrice(data); %optPrice creates an array with the theoretical price value for calls/puts
%putarray = squeeze(putarray(ind1:ind2,:));
yaxis = 'openInterest';

%can fix the indexing issue by limiting the number of entries. Will keep
%plus/minus 25 strikes from the spot

if strcmp(calorputs,'calls')
    %poop = data.optionChain.result.options.calls;
    %lengt = length(poop);
    if isstruct(data.optionChain.result.options.calls)
        for ii  = 1:netind
            jj = jj+1;
            %accessing elements from a XxY size struct is different than
            %normal, uses getfield vs extractfield
            
            try
                dota(ii,1) = getfield(data.optionChain.result.options.calls,{jj}, 'strike');
                dota(ii,2) = getfield(data.optionChain.result.options.calls, {jj}, yaxis);
            catch itdontexist
                disp('your data is garbage')
                dota(ii,2) = 0;
            end
            
        end
        array = dota;
    elseif iscell(data.optionChain.result.options.calls)
        for ii  = 1:netind 
            jj = jj+1;
            try
                dota(ii,1) = extractfield(data.optionChain.result.options.calls{jj}, 'strike');
                dota(ii,2) = extractfield(data.optionChain.result.options.calls{jj}, yaxis);
             catch e %e is an MException struct
                fprintf(1,'The identifier was:\n%s',e.identifier);
                fprintf(1,'There was an error! The message was:\n%s',e.message);
                dota(ii,2) = NaN;
                % more error handling...
            end     
            
        end
        array = dota;
    end
end    
%%same thing but for the put side of things    
if strcmp(calorputs,'puts')
    %poop = data.optionChain.result.options.puts;
    %lengt = length(poop);
    if isstruct(data.optionChain.result.options.puts)
        for ii  = 1:netind
        jj = jj+1;
            %accessing elements from a XxY size struct is different than
            %normal, uses getfield vs extractfield
            try
                dota(ii,1) = getfield(data.optionChain.result.options.puts,{jj}, 'strike');
                dota(ii,2) = getfield(data.optionChain.result.options.puts,{jj}, yaxis);
            catch itdontexist
                disp('your data is garbage')
                dota(ii,2) = 0;
            end
        array = dota;
        end
    elseif iscell(data.optionChain.result.options.puts)
        for ii  = 1:netind
            jj = jj+1;
            try
                dota(ii,1) = extractfield(data.optionChain.result.options.puts{jj}, 'strike');
                dota(ii,2) = extractfield(data.optionChain.result.options.puts{jj}, yaxis);
             catch e %e is an MException struct
                fprintf(1,'The identifier was:\n%s',e.identifier)
                fprintf(1,'There was an error! The message was:\n%s',e.message)
                dota(ii,2) = NaN;
                % more error handling...
            end
            array = dota;            
        end
    end
    %array(:,1) = putarray(:,1);
    %array(:,2) = (putarray(:,2) - dota(:,2));
end  
end
