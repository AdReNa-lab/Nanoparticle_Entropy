function [Entropy_Int] = Entropy_Sub_Func(SubPopulation, BinWidth)

%Obtains the number of particles in each bin using the provided Bin Width
rmin = floor(min(SubPopulation)/BinWidth)*BinWidth-0.5*BinWidth;
rmax = ceil(max(SubPopulation)/BinWidth)*BinWidth+0.5*BinWidth;

edges = rmin:BinWidth:rmax;
y = zeros(length(edges)-1, 1);

for i = 1:length(y)
    
    lower_lim = edges(i);
    upper_lim = edges(i+1);
    
    test_lower = (SubPopulation >= lower_lim);
    test_upper = (SubPopulation < upper_lim);
    test = test_lower.*test_upper;
    
    y(i) = sum(test);
    
end

%Obtains the number of outcomes (number of bins)
n = length(y);

%Normalises the area beneath the curve to obtain the probability of each
%outcome
num = length(SubPopulation);
p = y./num;

%Calculates the Entropy

%Determines the summation term
z = 0;
for i = 1:n
    if p(i) == 0
        z = z + 0;
    else 
        z = z + -1 * p(i) * log(p(i));
    end
end

%Calculates the exponent and multiplies it by the bin width to obtain the
%entropy
Entropy_Int = exp(sum(z)) * BinWidth;

end