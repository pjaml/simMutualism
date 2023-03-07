% [[file:mutual_ide.org::*Speed vs. time][Speed vs. time:1]]
function plotSpeedTime(simMatFile, varargin)

    p = inputParser;
    addRequired(p, 'simMatFile', @isfile);
    addOptional(p,'createFile', false, @islogical);
    addOptional(p, 'imgDir', './', @isfolder);

    parse(p, simMatFile, varargin{:});

    load(simMatFile, 'filename', 'iterations', 'instantSpeedP', 'instantSpeedF1', 'instantSpeedF2');

    plot(1:iterations, instantSpeedP, 1:iterations, instantSpeedF1, 1:iterations, instantSpeedF2);
    legend('P', 'F1', 'F2');
    title(strcat(['Spread speed vs. time']));
    xlabel('iterations');
    ylabel('speed');

    if p.Results.createFile
        filename = strcat('speed_time_', filename, '.fig');
        savefig(strcat(imgDir, filename));
    end
end
% Speed vs. time:1 ends here
