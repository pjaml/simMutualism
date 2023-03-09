% [[file:mutual_ide.org::*Speed vs. time][Speed vs. time:1]]
function plotSpeedTime(simMatFile, varargin)

    p = inputParser;
    addRequired(p, 'simMatFile', @isfile);
    addOptional(p,'createFile', true, @islogical);
    addOptional(p, 'figDir', './', @isfolder);

    parse(p, simMatFile, varargin{:});

    load(simMatFile, 'filename', 'iterations', 'instantSpeedP', 'instantSpeedF1', 'instantSpeedF2');

    plot(1:(iterations + 1), instantSpeedP, 1:(iterations + 1), instantSpeedF1, 1:(iterations + 1), instantSpeedF2);
    legend('P', 'F1', 'F2');
    title(strcat(['Spread speed vs. time']));
    xlabel('iterations');
    ylabel('speed');

    if p.Results.createFile
        [~, filename, ~] = fileparts(filename);
        filename = strcat('speed_time_', filename, '.fig');
        savefig(strcat(p.Results.figDir, filename));
    end
end
% Speed vs. time:1 ends here
