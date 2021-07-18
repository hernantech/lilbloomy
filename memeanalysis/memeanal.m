function [outputArg1,outputArg2] = memeanal(struct1,inputArg2)
%MEMEANAL a specific set of tools running analysis specifically for meme
%stocks, i.e. AMC/GME
%   input a struct of the relevant ticker (struct1) and outputs processed
%   data for relevant positioning. Ex: GME experiences a jump, expected
%   diffusion allows for option modeling based on pool liq, toxicity, etc,
%   such that traders can decide whether the premium/risk ratio is worth
%   entering a trade.


%cleaning data from struct



outputArg1 = merton
outputArg2 = inputArg2;
end

