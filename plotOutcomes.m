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

        curFile = load(fullfile(sweepDir, files(file).name), 'nF1', 'nF2', 'nThreshold', 'parameters');

        parameters = curFile.parameters;
        % get the values of tau12 and tau21
        tau12 = parameters{find(strcmp('tau12', parameters)) + 1};
        tau21 = parameters{find(strcmp('tau21', parameters)) + 1};

        finalNF1 = curFile.nF1(end,:);
        finalNF2 = curFile.nF2(end,:);

        curOutcome = classifyOutcome(finalNF1, finalNF2, curFile.nThreshold);

        disp(strcat("The outcome of tau12 = ", num2str(tau12, "%.2f"), " and tau21 = ", num2str(tau21, "%.2f"), " is ", num2str(curOutcome)));

        outcomes(tau12Range == tau12,tau21Range == tau21) = curOutcome;

        clear curFile;

    end

    disp("Saving outcomes plot...")
    figure(1);
    heatmap(tau12Range, fliplr(tau21Range), rot90(outcomes));
    xlabel('tau_{12}');
    ylabel('tau_{21}');

    filename = fullfile(figDir, 'tauSweepOutcomesPlot.fig');
    savefig(filename);

end
% Sweep outcomes plot:1 ends here
