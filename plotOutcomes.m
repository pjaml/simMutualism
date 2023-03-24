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

        curFile = matfile(fullfile(sweepDir, files(file).name));

        parameters = curFile.parameters;
        % get the values of tau12 and tau21
        tau12 = parameters{find(strcmp('tau12', parameters)) + 1};
        tau21 = parameters{find(strcmp('tau21', parameters)) + 1};

        disp(strcat("The outcome of tau12 = ", num2str(tau12, "%.2f"), " and tau21 = ", num2str(tau21, "%.2f"), " is ", num2str(curFile.outcome)));

        % You can't use == for comparison of floating point numbers, you have to
        % use this ismembertol function The default tolerance is fine for this
        % purpose.
        outcomes(ismembertol(tau12Range, tau12), ismembertol(tau21Range, tau21)) = curFile.outcome;

        clear curFile;

    end

    disp("Saving outcomes plot...")
    f = figure('visible', 'off');
    heatmap(tau12Range, fliplr(tau21Range), rot90(outcomes));
    xlabel('tau_{12}');
    ylabel('tau_{21}');

    filename = fullfile(figDir, 'tauSweepOutcomesPlot');
    saveas(f, strcat(filename, '.fig');
    saveas(f, strcat(filename, '.png');

end
% Sweep outcomes plot:1 ends here
