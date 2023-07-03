% [[file:mutual_ide.org::*Generate figures from paper][Generate figures from paper:1]]
function generatePlots(sweepDir, figDir, varargin)

    defaultTau12Range = 0.13:0.01:0.31;
    defaultTau21Range = 0.0:0.01:0.4;

    p = inputParser;
    addRequired(p, 'sweepDir', @isfolder);
    addRequired(p, 'figDir');
    addParameter(p, 'plotOutcomes', false, @islogical);
    addParameter(p, 'plotPopSpaceTime', false, @islogical);
    addParameter(p, 'plotFinalPopSpace', false, @islogical);
    addParameter(p, 'plotSpeedTime', false, @islogical);
    addParameter(p, 'tau12Range', defaultTau12Range, @isvector);
    addParameter(p, 'tau21Range', defaultTau21Range, @isvector);
    addParameter(p, 'taus', [], @ismatrix);

    parse(p, sweepDir, figDir, varargin{:});

    mkdir(figDir)

    if p.Results.plotOutcomes
        % get the heatmap of all the outcomes
        disp('Generating outcomes plot...')
        if isfolder(figDir)
            plotOutcomes(sweepDir, 'figDir', figDir);
        else
            error("figDir is not a folder")
        end
    end

    if p.Results.plotPopSpaceTime || p.Results.plotFinalPopSpace || p.Results.plotSpeedTime

        tau12Range = p.Results.tau12Range;
        tau21Range = p.Results.tau21Range;
        taus = p.Results.taus;

        % check to make sure generatePlots is given either tau ranges or pairs but not both
        if ~(isequal(tau12Range, defaultTau12Range) && isequal(tau21Range, defaultTau21Range)) && ~isempty(taus)

            error("Specify values for tau ranges or a vector of tau pair values, but not both")
        end

        if isempty(taus)
            for tau12 = tau12Range

                taus = [taus; ones(numel(tau21Range), 1) * tau12, tau21Range(:)];

            end
        end

        for i = 1:height(taus)

            formatSpec = '%.2f';
    
            % probably a better way to do this with regexp
            targetFile = dir(fullfile(sweepDir, strcat("*tau12_", num2str(taus(i, 1), formatSpec), "*tau21_", num2str(taus(i, 2), formatSpec), "*.mat")));

            disp(targetFile)
            fname = fullfile(sweepDir, targetFile.name);

            curFile = load(fname, 'iterations', 'filename', 'nP', 'nF1', 'nF2', 'nThreshold', 'x', 'instantSpeedP', 'instantSpeedF1', 'instantSpeedF2', 'diameter');

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
end
% Generate figures from paper:1 ends here
