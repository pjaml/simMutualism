% [[file:mutual_ide.org::*Speed vs. time plot][Speed vs. time plot:1]]
function plotSpeedTime(simMatFile, varargin)

    p = inputParser;
    addRequired(p, 'simMatFile');
    addOptional(p,'createFig', true, @islogical);
    addOptional(p, 'figDir', './', @isfolder);

    parse(p, simMatFile, varargin{:});

    filename = simMatFile.filename;
    iterations = simMatFile.iterations;
    instantSpeedP = simMatFile.instantSpeedP;
    instantSpeedF1 = simMatFile.instantSpeedF1;
    instantSpeedF2 = simMatFile.instantSpeedF2;

    plot(1:iterations, instantSpeedP, 1:iterations, instantSpeedF1, 1:iterations, instantSpeedF2);
    legend('P', 'F1', 'F2');
    title(strcat(['Spread speed vs. time']));
    xlabel('iterations');
    ylabel('speed');

    if p.Results.createFig
        [~, filename, ~] = fileparts(filename);
        filename = strcat('speed_time_', filename, '.fig');
        savefig(strcat(p.Results.figDir, filename));
        clf;
    end
end
% Speed vs. time plot:1 ends here
