
function dota = evalOptData(data, calorputs, yaxis)
% Takes in (data, calorputs, yaxis), where data is the struct containing
% option data, calorputs is 'calls' or 'puts', and yaxis is the variable we
% seek to show, i.e. 'volume' or 'openInterest', etc.

dota = [];

%yaxis = 'volume'; %the variable we're seeking for our Y
if strcmp(calorputs, 'calls')
    poop = data.optionChain.result.options.calls;
    lengt = length(poop);
    if isstruct(data.optionChain.result.options.calls)
        for ii  = 1:lengt 
            %accessing elements from a XxY size struct is different than
            %normal, uses getfield vs extractfield
            dota(ii,1) = getfield(data.optionChain.result.options.calls,{ii}, 'strike');
            try
                dota(ii,2) = getfield(data.optionChain.result.options.calls, {ii}, yaxis);
            catch itdontexist
                disp('your data is garbage')
                fprintf(1,'The identifier was:\n%s',e.identifier);
                fprintf(1,'There was an error! The message was:\n%s',e.message);
                % more error handling...
            end
        end
    elseif iscell(data.optionChain.result.options.calls)
        for ii  = 1:lengt 
            try
                dota(ii,1) = extractfield(data.optionChain.result.options.calls{ii}, 'strike');
                dota(ii,2) = extractfield(data.optionChain.result.options.calls{ii}, yaxis);
             catch e %e is an MException struct
                fprintf(1,'The identifier was:\n%s',e.identifier);
                fprintf(1,'There was an error! The message was:\n%s',e.message);
                % more error handling...
            end
            
            
            
        end
    end
%%same thing but for the put side of things    
elseif strcmp(calorputs, 'puts')
    poop = data.optionChain.result.options.puts;
    lengt = size(poop);
    lengt = lengt(1);
    if isstruct(data.optionChain.result.options.puts)
        for ii  = 1:lengt 
            %accessing elements from a XxY size struct is different than
            %normal, uses getfield vs extractfield
            dota(ii,1) = getfield(data.optionChain.result.options.puts,{ii}, 'strike');
            try
                dota(ii,2) = getfield(data.optionChain.result.options.puts, {ii}, yaxis);
            catch itdontexist
                disp('your data is garbage')
            end
        end
    elseif iscell(data.optionChain.result.options.puts)
        for ii  = 1:lengt 
            try
                dota(ii,1) = extractfield(data.optionChain.result.options.puts{ii}, 'strike');
                dota(ii,2) = extractfield(data.optionChain.result.options.puts{ii}, yaxis);
             catch e %e is an MException struct
                fprintf(1,'The identifier was:\n%s',e.identifier);
                fprintf(1,'There was an error! The message was:\n%s',e.message);
                % more error handling...
            end
            
            
            
        end
    end
end      
end
