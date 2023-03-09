% [[file:mutual_ide.org::*Speed vs. time][Speed vs. time:1]]
function plotSpeedTime(simMatFile, varargin)

    p = inputParser;
    addRequired(p, 'simMatFile', @isfile);
    addOptional(p,'createFig', true, @islogical);
    addOptional(p, 'figDir', './', @isfolder);

    parse(p, simMatFile, varargin{:});

    curFile = load(simMatFile, 'filename', 'iterations', 'instantSpeedP', 'instantSpeedF1', 'instantSpeedF2');

    iterations = curFile.iterations;

    plot(1:(iterations + 1), curFile.instantSpeedP, 1:(iterations + 1), curFile.instantSpeedF1, 1:(iterations + 1), curFile.instantSpeedF2);
    legend('P', 'F1', 'F2');
    title(strcat(['Spread speed vs. time']));
    xlabel('iterations');
    ylabel('speed');

    if p.Results.createFig
        [~, filename, ~] = fileparts(curFile.filename);
        filename = strcat('speed_time_', filename, '.fig');
        savefig(strcat(p.Results.figDir, filename));
    end

    clf;
    clear curFile;
end
% Speed vs. time:1 ends here
