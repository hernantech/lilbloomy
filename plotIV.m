
function  NewRange = plotIV()
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

Range = 10:70;
Span = length(Range);
j = 1:0.5:12;
Newj = j(ones(Span,1),:)'/12;

JSpan = ones(length(j),1);
NewRange = Range(JSpan,:);
Pad = ones(size(Newj));

ZVal = blsgamma(NewRange, 40*Pad, 0.1*Pad, Newj, 0.35*Pad);
Color = blsdelta(NewRange, 40*Pad, 0.1*Pad, Newj, 0.35*Pad);

mesh(Range, j, ZVal, Color);
xlabel('Stock Price ($)');
ylabel('Time (months)');
zlabel('Gamma');
title('Call option price sensitivity');
axis([10 70  1 12  -inf inf]);
view(-40, 50);
colorbar('vert');


%outputArg1 = inputArg1;
%outputArg2 = inputArg2;
end

