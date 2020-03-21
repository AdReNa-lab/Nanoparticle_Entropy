function [Entropy, RI] = Entropy_Function(Population_Data, BinWidth)
%Entropy_Function is the main file for calculating entropy. It requires the
%additional function, Entropy_Sub_Func.m, to be saved in the same folder.
%
%Inputs:
%   Population Data
%       The name for the column vector containing the population size data
%   BinWidth
%       The width for each bin used to make a histogram of the data.
%       Ideally the resolution of the measurement of the particle size
%       would be used as the bin width but n practice, common binning, as 
%       used to display particle size histograms based on TEM analysis, is 
%       appropriate for entropy calculations (BinWidth < 0.5*Standard
%       Deviation)
%
%Output:
%   Entropy
%       The entropy is calculated based on the provided population data and
%       bin width.  If the sample size is small or heterodisperse, it may
%       be beneficial to repeat the entropy calculation and obtain the
%       mean. 

%Determines the size of the main population and the two subpopulatoins
N = length(Population_Data);
N1 = round(N/2);
N2 = round(N/4);

%The two subpopulatons are randomly drawn from the main population and the
%coresponding entropy values are calculated by Entropy_Sub_Func
A1 = datasample(Population_Data,N1);
E1 = Entropy_Sub_Func(A1, BinWidth);

A2 = datasample(Population_Data,N2);
E2 = Entropy_Sub_Func(A2, BinWidth);

[E] = Entropy_Sub_Func(Population_Data, BinWidth);

%In order to perform a sample size correction, these three points are 
%fitted to the quadratic equation, QE_fun

%Initial guesses [I, a, b];
Parameter_guess = [E, 0, 0];

%Three data points
X = [N, N1, N2]';
Y = [E, E1, E2]';

%The quadratic function
QE_fun = 'I + a/x + b/(x^2)';

%This fits the three data points to the quadratic function
f1 = fit(X,Y,QE_fun,'Start', Parameter_guess);

%The entropy corrected for sample size is reported
Entropy = f1.I;

%The Reliability Index is calculated
RI = ((E - E1)/(N - N1))*BinWidth;

end
