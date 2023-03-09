% [[file:mutual_ide.org::*Sweep outcomes plot][Sweep outcomes plot:1]]
function plotOutcomes(sweepDir, varargin)

    p = inputParser;

    addRequired(p, 'sweepDir', @isfolder);
    addParameter(p, 'tau12Range', 0:0.01:0.40);
    addParameter(p, 'tau21Range', 0:0.01:0.40);
    addParameter(p, 'figDir', './', @isfolder);
    parse(p, sweepDir, varargin{:});

    tau12Range = p.Results.tau12Range;
    tau21Range = p.Results.tau21Range;
    figDir = p.Results.figDir;

    outcomes = zeros(length(tau12Range), length(tau21Range));

    files = dir(fullfile(sweepDir, '*.mat'));

    for file = 1:length(files)

        load(strcat(sweepDir, files(file).name), 'nF1', 'nF2', 'nThreshold', 'parameters');

        % get the values of tau12 and tau21
        tau12 = parameters{find(strcmp('tau12', parameters)) + 1};
        tau21 = parameters{find(strcmp('tau21', parameters)) + 1};

        % get the outcomes index of the tau12 and tau21 values
        tau12Index = find(tau12Range == tau12);
        tau21Index = find(tau21Range == tau21);

        finalNF1 = nF1(end,:);
        finalNF2 = nF2(end,:);

        outcomes(tau12Index,tau21Index) = classifyOutcome(finalNF1, finalNF2, nThreshold);

    end

    figure(1);
    heatmap(tau12Range, fliplr(tau21Range), rot90(outcomes));
    axis square;
    xlabel('tau_{12}');
    ylabel('tau_{21}');

    filename = strcat(figDir, 'tauSweepOutcomesPlot.fig');
    savefig(filename);

end
% Sweep outcomes plot:1 ends here
