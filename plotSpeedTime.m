% [[file:mutual_ide.org::*Speed vs. time plot][Speed vs. time plot:1]]
function plotSpeedTime(simMatFile, varargin)

    p = inputParser;
    addRequired(p, 'simMatFile');
    addOptional(p,'createFile', true, @islogical);
    addOptional(p, 'figDir', './', @isfolder);

    parse(p, simMatFile, varargin{:});

    filename = simMatFile.filename;
    iterations = simMatFile.iterations;
    instantSpeedP = simMatFile.instantSpeedP;
    instantSpeedF1 = simMatFile.instantSpeedF1;
    instantSpeedF2 = simMatFile.instantSpeedF2;

    if p.Results.createFile
        f = figure('visible', 'off');
    else
        figure(1);
    end

    plot(1:iterations, instantSpeedP, 1:iterations, instantSpeedF1, 1:iterations, instantSpeedF2);
    legend('P', 'F1', 'F2');
    title(strcat(['Spread speed vs. time']));
    xlabel('iterations');
    ylabel('speed');

    if p.Results.createFile
        [~, filename, ~] = fileparts(filename);
        filename = fullfile(p.Results.figDir, strcat('speed_time_', filename));
        saveas(f, strcat(filename, '.fig'));
        saveas(f, strcat(filename, '.png'));
    end
end
% Speed vs. time plot:1 ends here
