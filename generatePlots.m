% [[file:mutual_ide.org::*Generate figures from paper][Generate figures from paper:1]]
function generatePlots(sweepDir, outputDir, varargin)

    p = inputParser;
    addRequired(p, 'sweepDir', @isfolder);
    addRequired(p, 'figDir', @isfolder);
    addParameter(p, 'plotOutcomes', false, @islogical);
    addParameter(p, 'plotPopSpaceTime', false, @islogical);
    addParameter(p, 'plotFinalPopSpace', false, @islogical);
    addParameter(p, 'plotSpeedTime', false, @islogical);
    addParameter(p, 'tau12Range', 0.13:0.01:0.31, @isvector);
    addParameter(p, 'tau21Range', 0.0:0.01:0.4, @isvector);

    parse(p, sweepDir, figDir, varargin{:});

    tau12Range = p.Results.tau12Range;
    tau21Range = p.Results.tau21Range;

    mkdir(figDir)

    if p.Results.plotOutcomes
        % get the heatmap of all the outcomes
        disp('Generating outcomes plot...')
        plotOutcomes(sweepDir, 'figDir', figDir);
    end

    formatSpec = '%.2f';

    taus = [];

    for tau12 = tau12Range

        taus = [taus; ones(numel(tau21Range), 1) * tau12, tau21Range(:)];

    end

    for i = 1:length(taus)

        % probably a better way to do this with regexp
        targetFile = dir(fullfile(sweepDir, strcat("*tau12_", num2str(taus(i, 1), formatSpec), "*tau21_", num2str(taus(i, 2), formatSpec), "*.mat")));

        filename = fullfile(sweepDir, targetFile.name);

        curFile = load(filename, 'iterations', 'filename', 'nP', 'nF1', 'nF2', 'nThreshold', 'x', 'instantSpeedP', 'instantSpeedF1', 'instantSpeedF2');

        if p.Results.plotPopSpaceTime
            plotPopSpaceTime(curFile, 'figDir', figDir);
        end

        if p.Results.plotFinalPopSpace
            plotFinalPopSpace(curFile, 'figDir', figDir);
        end

        if p.Results.plotSpeedTime
            plotSpeedTime(curFile, 'figDir', figDir);
        end

        clear curFile;
    end
end
% Generate figures from paper:1 ends here
