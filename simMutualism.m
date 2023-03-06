function simMutualism(outputDir, varargin)

% we save the given parameters to a variable so we can use them to
% name files and label plots
parameters = varargin;

%% for simulation

p = inputParser;
p.KeepUnmatched = true;

% minimum number of cycles of growth and dispersal
addParameter(p, 'iterations', 60);
addParameter(p, 'maxIterations', 500);
addParameter(p, 'iterationStep', 100);
addRequired(p, 'outputDir', @isfolder);

parse(p, outputDir, varargin{:});

% I wish I knew a better way to get rid of all the p.Results that get attached inputParser parameters
iterations = p.Results.iterations;
maxIterations = p.Results.maxIterations;
iterationStep = p.Results.iterationStep;
outputDir = p.Results.outputDir;

% threshold for speed variance at steady state
steadyStateThreshold = 1e-04;

% format spec for floating point values in filenames
fspec = '%.2f';

%% Initialize space parameters
lowval = 1e-9;
diameter = 1200;  %total size of landscape along positive x-axis (so technically half the size of the total landscape)
nodes = (2^16) + 1; %total points in space -- 65537
radius = diameter / 2;
x = linspace(-radius, radius, nodes);
x2 = linspace(-diameter, diameter, 2 * nodes - 1);
dx = diameter / (nodes - 1);

[instantSpeedP, avgSpeedP, instantSpeedF1, avgSpeedF1, instantSpeedF2, avgSpeedF2] = deal(zeros(1, maxIterations)); % preallocate arrays for max possible iterations

[rangeEdgeP,rangeEdgeF1, rangeEdgeF2] = deal(zeros(1, maxIterations));

[nP, nF1, nF2] = deal(zeros(maxIterations, length(x)));

sigma_sq = 0.25; % Dispersal variance

% gaussian dispersal kernels
kP = exp(-(x2.^2)/(2*sigma_sq))./sqrt(2*pi*sigma_sq);
kF1 = exp(-(x2.^2)/(2*sigma_sq))./sqrt(2*pi*sigma_sq);
kF2 = exp(-(x2.^2)/(2*sigma_sq))./sqrt(2*pi*sigma_sq);

% SET THE INITIAL CONDITIONS
irad = 2; % Initial condition range
initDensities = [0.1,0.1,0.1];
nThreshold = 0.05; % critical threshold for edge of wave
temp_P = find(abs(x) <= irad); %locate all values in the array x that lie b/w +irad and -irad units of space
temp_F1 = find(abs(x) <= irad);
temp_F2 = find(abs(x) <= irad);

nP(1,temp_P) = initDensities(1) * normpdf(x(temp_P),0,1); %Computes pdf values evaluated at the values in x i.e. all x(temp) values for the normal distribution with mean 0 and standard deviation 1.
nF1(1,temp_F1) = initDensities(2) * normpdf(x(temp_F1),0,1);
nF2(1,temp_F2) = initDensities(3) * normpdf(x(temp_F2),0,1);

% FIND THE INITIAL FRONT LOCATION
jj_P = find(nP(1,:) >= nThreshold,1,'last'); %find the farthest distance travelled by the population above a certain threshold density and assign it to jj
jj_F1 = find(nF1(1,:) >= nThreshold,1,'last');
jj_F2 = find(nF2(1,:) >= nThreshold,1,'last');

if jj_P %the initial front is obtained from initialization which will be in the first row of 'n'
  rangeEdgeP(1) = interp1(nP(1,jj_P:jj_P+1),x(jj_P:jj_P+1),nThreshold);
end
if jj_F1
  rangeEdgeF1(1) = interp1(nF1(1,jj_F1:jj_F1+1),x(jj_F1:jj_F1+1),nThreshold);
end

if jj_F2
  rangeEdgeF2(1) = interp1(nF2(1,jj_F2:jj_F2+1),x(jj_F2:jj_F2+1),nThreshold);
end

generation = 1;
%% Looping for growth and dispersal
while generation <= iterations

    % for ode45
    tspan = [0, 10];

    %Growth
    y0 = [nP(generation,:);nF1(generation,:);nF2(generation,:)];

    % reshape happens such that 3 consecutive rows for nP, nF1, and nF2 values are stacked
    y0 = reshape(y0, 3*length(y0), 1);

    [t,y] = ode45(@(t,y) growthODEs(t,y), tspan, y0); %remember to alter where the dep_p and dep_f are being called from


    % We just want the results of the growth phase (end)
    fP = y(end,(1:3:end)); % final row; element 1, +3, elem. 4, etc. until end
    fF1 = y(end,(2:3:end));
    fF2 = y(end,(3:3:end));

%   DISPERSAL
    n1P = fft_conv(kP,fP);   % dispersing individuals
    n1F1 = fft_conv(kF1,fF1);
    n1F2 = fft_conv(kF2,fF2);

    nP(generation + 1,:) = dx*n1P(nodes:length(x2)); %the convolution apparently doubles the length of the array?
    nF1(generation + 1,:) = dx*n1F1(nodes:length(x2));
    nF2(generation + 1,:) = dx*n1F2(nodes:length(x2));

    nP(generation + 1,1) = nP(generation + 1,1)/2; nP(generation + 1,nodes) = nP(generation + 1,nodes)/2; %The population density at the edges is halved

    nF1(generation + 1,1) = nF1(generation + 1,1)/2; nF1(generation + 1,nodes) = nF1(generation + 1,nodes)/2;

    nF2(generation + 1,1) = nF2(generation + 1,1)/2; nF2(generation + 1,nodes) = nF2(generation + 1,nodes)/2;

    temp_P = find(nP(generation + 1,:) < lowval); %gives location of random places where numbers are above zero due to some numerical errors
    temp_F1 = find(nF1(generation + 1,:) < lowval);
    temp_F2 = find(nF2(generation + 1,:) < lowval);

    nP(generation + 1,temp_P) = zeros(size(nP(generation + 1,temp_P))); %set the places with those numerical errors to zero
    nF1(generation + 1,temp_F1) = zeros(size(nF1(generation + 1,temp_F1)));%delete this for STE
    nF2(generation + 1,temp_F2) = zeros(size(nF2(generation + 1,temp_F2)));%delete this for STE

    jj_P = find(nP(generation + 1,:) >= nThreshold,1,'last');
    jj_F1 = find(nF1(generation + 1,:) >= nThreshold,1,'last');
    jj_F2 = find(nF2(generation + 1,:) >= nThreshold,1,'last');

    if jj_P
         rangeEdgeP(generation + 1) = interp1(nP(generation + 1,jj_P:jj_P + 1),x(jj_P:jj_P + 1),nThreshold);
    end

    if jj_F1
         rangeEdgeF1(generation + 1) = interp1(nF1(generation + 1,jj_F1:jj_F1 + 1),x(jj_F1:jj_F1 + 1),nThreshold);
    end

    if jj_F2
         rangeEdgeF2(generation + 1) = interp1(nF2(generation + 1,jj_F2:jj_F2 + 1),x(jj_F2:jj_F2 + 1),nThreshold);
    end

    avgSpeedP(generation) = (rangeEdgeP(generation + 1) - rangeEdgeP(1)) / generation; %latest position of wave edge - initial position of wave edge divided by time
    instantSpeedP(generation) = rangeEdgeP(generation + 1) - rangeEdgeP(generation);

    instantSpeedF1(generation) = rangeEdgeF1(generation + 1) - rangeEdgeF1(generation);
    avgSpeedF1(generation) = (rangeEdgeF1(generation + 1) - rangeEdgeF1(1)) / generation; %latest position of wave edge - initial position of wave edge divided by time

    instantSpeedF2(generation) = rangeEdgeF2(generation + 1) - rangeEdgeF2(generation);
    avgSpeedF2(generation) = (rangeEdgeF2(generation + 1) - rangeEdgeF2(1)) / generation; %latest position of wave edge - initial position of wave edge divided by time

    % check for steady state, and determine whether to run for more generations
    if (generation == iterations)

        % if not all species at steady state
        if ~(isSpeciesSteadyState(instantSpeedP, steadyStateThreshold, generation) && isSpeciesSteadyState(instantSpeedF1, steadyStateThreshold, generation) && isSpeciesSteadyState(instantSpeedF2, steadyStateThreshold, generation))

            % iterations close to the max
            if iterations >= (maxIterations - iterationStep)
                iterations = maxIterations;
            else
                iterations = iterations + iterationStep;
            end
        end
    end

    generation = generation + 1;

% while loop end
end

%% Save a mat file with the current parameter values

nP = nP(1:(iterations + 1), :);
nF1 = nF1(1:(iterations + 1), :);
nF2 = nF2(1:(iterations + 1), :);

instantSpeedP(1, 1:(iterations + 1));
instantSpeedF1(1, 1:(iterations + 1));
instantSpeedF2(1, 1:(iterations + 1));

filename = strcat('results_', strjoin(string(parameters), '_'));

save(strcat(outputDir, filename, '.mat'), 'nP', 'nF1', 'nF2', 'iterations', 'nThreshold', 'instantSpeedP', 'instantSpeedF1', 'instantSpeedF2', 'filename', 'parameters', 'x');

% end of simMutualism function
end
