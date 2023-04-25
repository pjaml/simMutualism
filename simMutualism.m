% [[file:mutual_ide.org::*Simulation][Simulation:1]]
function simMutualism(varargin)

% we save the given parameters to a variable so we can use them to
% name files and label plots
parameters = varargin;
% Simulation:1 ends here

% [[file:mutual_ide.org::*Simulation parameters][Simulation parameters:1]]
%% for simulation

p = inputParser;
p.KeepUnmatched = true;

% minimum number of cycles of growth and dispersal
addParameter(p, 'iterations', 50, @isnumeric);
addParameter(p, 'maxIterations', 1000, @isnumeric);
addParameter(p, 'iterationStep', 50, @isnumeric);
addParameter(p, 'outputDir', './', @isfolder);
addParameter(p, 'steadyStateThreshold', 1e-03, @isnumeric);
addParameter(p, 'diameter', 1200, @isnumeric);
addParameter(p, 'sigma_sq', 0.05, @isnumeric); % Dispersal variance
addParameter(p, 'deltaP', 0.0, @isnumeric);
addParameter(p, 'deltaF1', 0.9, @isnumeric);
addParameter(p, 'deltaF2', 0.1, @isnumeric);
addParameter(p, 'useDeltaDispKernels', false, @islogical);


parse(p, varargin{:});

% I wish I knew a better way to get rid of all the p.Results that get attached
% inputParser parameters
iterations = p.Results.iterations;
maxIterations = p.Results.maxIterations;
sigma_sq = p.Results.sigma_sq;
deltaP = p.Results.deltaP;
deltaF1 = p.Results.deltaF1;
deltaF2 = p.Results.deltaF2;

if iterations > maxIterations
    disp("Warning: the value of iterations is greater than or ");
    disp("equal to maxIterations, so maxIterations has been increased.");
    maxIterations = iterations;
end

iterationStep = p.Results.iterationStep;
outputDir = p.Results.outputDir;
steadyStateThreshold = p.Results.steadyStateThreshold;

%total size of landscape along positive x-axis (so half the total landscape)
diameter = p.Results.diameter;
% Simulation parameters:1 ends here

% [[file:mutual_ide.org::*Space parameters][Space parameters:1]]
%% Initialize space parameters
lowval = 1e-9;
nodes = (2^16) + 1; %total points in space -- 65537
radius = diameter / 2;
x = linspace(-radius, radius, nodes);
x2 = linspace(-diameter, diameter, 2 * nodes - 1);
dx = diameter / (nodes - 1);
% Space parameters:1 ends here

% [[file:mutual_ide.org::*Initialization][Initialization:1]]
% preallocate arrays for max possible iterations + 1
[instantSpeedP, avgSpeedP, instantSpeedF1, avgSpeedF1, instantSpeedF2, avgSpeedF2] = deal(zeros(1, maxIterations + 1));

[rangeEdgeP,rangeEdgeF1, rangeEdgeF2] = deal(zeros(1, maxIterations + 1));

[nP, nF1, nF2] = deal(zeros(maxIterations + 1, length(x)));
% Initialization:1 ends here

% [[file:mutual_ide.org::*Dispersal kernels][Dispersal kernels:1]]
if p.Results.useDeltaDispKernels
    % gaussian dispersal kernels
    kP = exp(-(x2 .^ 2) / (2 * sigma_sq)) ./ sqrt(2 * pi * sigma_sq);
    kF1 = exp(-(x2 .^ 2) / (2 * sigma_sq * deltaF1)) ./ sqrt(2 * pi * sigma_sq * deltaF1);
    kF2 = exp(-(x2 .^ 2) / (2 * sigma_sq * deltaF2)) ./ sqrt(2 * pi * sigma_sq * deltaF2);
else
    kP = exp(-(x2 .^ 2) / (2 * sigma_sq)) ./ sqrt(2 * pi * sigma_sq);
    kF1 = exp(-(x2 .^ 2) / (2 * sigma_sq)) ./ sqrt(2 * pi * sigma_sq);
    kF2 = exp(-(x2 .^ 2) / (2 * sigma_sq)) ./ sqrt(2 * pi * sigma_sq);
end
% Dispersal kernels:1 ends here

% [[file:mutual_ide.org::*Initial population densities][Initial population densities:1]]
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
% Initial population densities:1 ends here

% [[file:mutual_ide.org::*Initial front location][Initial front location:1]]
% FIND THE INITIAL FRONT LOCATION
% find the farthest distance travelled by the population above a certain threshold density and assign it to front
frontP = find(nP(1,:) >= nThreshold,1,'last');
frontF1 = find(nF1(1,:) >= nThreshold,1,'last');
frontF2 = find(nF2(1,:) >= nThreshold,1,'last');

% the initial front is obtained from initialization which will be in the first
% row of 'n'
if frontP
  rangeEdgeP(1) = interp1(nP(1,frontP:frontP+1),x(frontP:frontP+1),nThreshold);
end
if frontF1
  rangeEdgeF1(1) = interp1(nF1(1,frontF1:frontF1+1),x(frontF1:frontF1+1),nThreshold);
end

if frontF2
  rangeEdgeF2(1) = interp1(nF2(1,frontF2:frontF2+1),x(frontF2:frontF2+1),nThreshold);
end
% Initial front location:1 ends here

% [[file:mutual_ide.org::*Simulating growth and dispersal over many generations][Simulating growth and dispersal over many generations:1]]
generation = 1;
%% Looping for growth and dispersal
while generation <= iterations
% Simulating growth and dispersal over many generations:1 ends here

% [[file:mutual_ide.org::*Growth phase][Growth phase:1]]
    % for ode45
    tspan = [0, 10];

    %Growth
    y0 = [nP(generation,:);nF1(generation,:);nF2(generation,:)];

    % reshape happens such that 3 consecutive rows for nP, nF1, and nF2 values
    % are stacked
    y0 = reshape(y0, 3*length(y0), 1);

    %remember to alter where the dep_p and dep_f are being called from
    [t,y] = ode45(@(t,y) growthODEs(t,y, varargin{:}), tspan, y0);


    % We just want the results of the growth phase (end)
    fP = y(end,(1:3:end)); % final row; element 1, +3, elem. 4, etc. until end
    fF1 = y(end,(2:3:end));
    fF2 = y(end,(3:3:end));
% Growth phase:1 ends here

% [[file:mutual_ide.org::*Dispersal phase][Dispersal phase:1]]
%   DISPERSAL
    n1P = fft_conv(kP,fP);
    n1F1 = fft_conv(kF1,fF1);
    n1F2 = fft_conv(kF2,fF2);

    nP(generation + 1,:) = dx*n1P(nodes:length(x2));
    nF1(generation + 1,:) = dx*n1F1(nodes:length(x2));
    nF2(generation + 1,:) = dx*n1F2(nodes:length(x2));

    nP(generation + 1,1) = nP(generation + 1,1)/2;
    nP(generation + 1,nodes) = nP(generation + 1,nodes)/2;

    nF1(generation + 1,1) = nF1(generation + 1,1)/2;
    nF1(generation + 1,nodes) = nF1(generation + 1,nodes)/2;

    nF2(generation + 1,1) = nF2(generation + 1,1)/2;
    nF2(generation + 1,nodes) = nF2(generation + 1,nodes)/2;

    % gives location of random places where numbers are above zero due to some
    % numerical errors
    temp_P = find(nP(generation + 1,:) < lowval);
    temp_F1 = find(nF1(generation + 1,:) < lowval);
    temp_F2 = find(nF2(generation + 1,:) < lowval);

    % set the places with those numerical errors to zero
    nP(generation + 1,temp_P) = zeros(size(nP(generation + 1,temp_P)));
    nF1(generation + 1,temp_F1) = zeros(size(nF1(generation + 1,temp_F1)));
    nF2(generation + 1,temp_F2) = zeros(size(nF2(generation + 1,temp_F2)));

    frontP = find(nP(generation + 1,:) >= nThreshold,1,'last');
    frontF1 = find(nF1(generation + 1,:) >= nThreshold,1,'last');
    frontF2 = find(nF2(generation + 1,:) >= nThreshold,1,'last');

    % if any of the species' range edge is equal to the edge of the entire
    % spatial range, stop the growth-dispersal loop. We set total iterations to
    % the last iteration + 1 so the data is still usable.
    if (frontP == nodes) | (frontF1 == nodes) | (frontF2 == nodes)
        error("Error: the simulation has stopped because the edge of the landscape was reached.");
    end

    if frontP
         rangeEdgeP(generation + 1) = interp1(nP(generation + 1,frontP:frontP + 1),x(frontP:frontP + 1), nThreshold);
    end

    if frontF1
         rangeEdgeF1(generation + 1) = interp1(nF1(generation + 1, frontF1:frontF1 + 1), x(frontF1:frontF1 + 1), nThreshold);
    end

    if frontF2
         rangeEdgeF2(generation + 1) = interp1(nF2(generation + 1,frontF2:frontF2 + 1), x(frontF2:frontF2 + 1), nThreshold);
    end

    %latest position of wave edge - initial position of wave edge divided by time
    avgSpeedP(generation) = (rangeEdgeP(generation + 1) - rangeEdgeP(1)) / generation;

    instantSpeedP(generation) = rangeEdgeP(generation + 1) - rangeEdgeP(generation);

    instantSpeedF1(generation) = rangeEdgeF1(generation + 1) - rangeEdgeF1(generation);

    %latest position of wave edge - initial position of wave edge divided by time
    avgSpeedF1(generation) = (rangeEdgeF1(generation + 1) - rangeEdgeF1(1)) / generation;

    %latest position of wave edge - initial position of wave edge divided by time
    instantSpeedF2(generation) = rangeEdgeF2(generation + 1) - rangeEdgeF2(generation);
    avgSpeedF2(generation) = (rangeEdgeF2(generation + 1) - rangeEdgeF2(1)) / generation;
% Dispersal phase:1 ends here

% [[file:mutual_ide.org::*Determine whether to continue running the simulation for more iterations][Determine whether to continue running the simulation for more iterations:1]]
    % check for steady state, and determine whether to run for more generations
    if (generation == iterations)

        % if not all species at steady state
        if ~(isSpeciesSteadyState(instantSpeedP, steadyStateThreshold, generation) && isSpeciesSteadyState(instantSpeedF1, steadyStateThreshold, generation) && isSpeciesSteadyState(instantSpeedF2, steadyStateThreshold, generation))

            % end the simulation if you've hit maxIterations
            if generation == maxIterations
                msg = strcat("Warning: The simulation for tau12 = ", num2str(p.Unmatched.tau12), " and tau21 = ", num2str(p.Unmatched.tau21), " has reached the maxIterations value of ", num2str(maxIterations), ".");
                disp(msg)
                break
            end

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
% Determine whether to continue running the simulation for more iterations:1 ends here

% [[file:mutual_ide.org::*Generate and save a mat file for the simulation][Generate and save a mat file for the simulation:1]]
%% Save a mat file with the current parameter values

nP = nP(1:(iterations + 1), :);
nF1 = nF1(1:(iterations + 1), :);
nF2 = nF2(1:(iterations + 1), :);

instantSpeedP = instantSpeedP(1, 1:(iterations + 1));
instantSpeedF1 = instantSpeedF1(1, 1:(iterations + 1));
instantSpeedF2 = instantSpeedF2(1, 1:(iterations + 1));

% classify outcome here so we don't have to do it later
outcome = classifyOutcome(nF1(end,:), nF2(end,:), nThreshold);

%% Save a mat file with the current parameter values

filename = 'results';
formatSpec = '%.2f';

if ~(isempty(parameters))
    for i = 1:length(parameters)
        param = parameters{i};

        if isnumeric(param)
            param = num2str(param, formatSpec);
        elseif strcmp(param, 'outputDir') || islogical(param) || isfolder(param)
            continue
        else
            param = string(param);
        end

        filename = strcat(filename, '_', param);
    end
end

filename = strcat(filename, '.mat');

save(strcat(outputDir, filename), 'nP', 'nF1', 'nF2', 'iterations', 'nThreshold', 'instantSpeedP', 'instantSpeedF1', 'instantSpeedF2', 'filename', 'parameters', 'x', 'maxIterations', 'diameter', 'outcome', 'steadyStateThreshold', 'kP', 'kF1', 'kF2');

% end of simMutualism function
end
% Generate and save a mat file for the simulation:1 ends here
