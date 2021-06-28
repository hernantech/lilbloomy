function dataforhist = freqdist2histarr(z)
%freqdist2histarr takes in a frequency distribution (like strike,volume
%data and outputs a list for a histogram
%   Detailed explanation goes here...or does it?

array = [];
for ii = 1:size(z(:,1))
    for yy = 1:z(ii,2)
        array(end+1) = z(ii,1);
    end
end

dataforhist = array;
end

