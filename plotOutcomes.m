% [[file:mutual_ide.org::*Sweep outcomes plot][Sweep outcomes plot:1]]
function plotOutcomes(sweepDir, varargin)

    p = inputParser;

    addRequired(p, 'sweepDir', @isfolder);
    addParameter(p, 'tau12Range', 0:0.01:0.40);
    addParameter(p, 'tau21Range', 0:0.01:0.40);
    addParameter(p, 'outputDir', './', @isfolder);
    parse(p, sweepDir, varargin{:});

    tau12Range = p.Results.tau12Range;
    tau21Range = p.Results.tau21Range;
    outputDir = p.Results.outputDir;

    outcomes = zeros(length(tau12Range), length(tau21Range));

    files = dir(fullfile(p.Results.sweepDir, '*.mat'));

    for file = 1:length(files)

        load(file.name, 'nF1', 'nF2', 'nThreshold', 'parameters');

        for i = 1:length(parameters)
            if strcmp(parameters{i}, 'tau12')
                tau12 = parameters{i + 1};
            end

            if strcmp(parameters{i}, 'tau21')
                tau21 = parameters{i + 1};
            end
        end

        finalNF1 = nF1(end,:);
        finalNF2 = nF2(end,:);

        outcomes(tau12,tau21) = classifyOutcome(finalNF1, finalNF2, nThreshold);

    end
end

figure(1)
heatmap(tau12Range, fliplr(tau21Range), rot90(outcomes));
xlabel('tau_{12}');
ylabel('tau_{21}');

filename = strcat(outputDir, 'tauSweepOutcomesPlot.fig');
savefig(filename);

end
% Sweep outcomes plot:1 ends here