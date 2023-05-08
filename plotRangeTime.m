% [[file:mutual_ide.org::*Range vs. time][Range vs. time:1]]
function plotRangeTime(simMatFile, varargin)

    p = inputParser;
    addRequired(p, 'simMatFile', @isfile);
    addOptional(p,'createFile', true, @islogical);
    addOptional(p, 'figDir', './', @isfolder);


    parse(p, simMatFile, varargin{:});

    load(simMatFile, 'filename', 'nThreshold', 'nP', 'nF1', 'nF2', 'iterations');

    for i = 1:(iterations + 1)

        rangeP(i) = length(find(nP(i,:) >= nThreshold));
        rangeF1(i) = length(find(nF1(i,:) >= nThreshold));
        rangeF2(i) = length(find(nF2(i,:) >= nThreshold));
    end

    if p.Results.createFile
        f = figure('visible', 'off');
    else
        figure(1);
    end

    plot(1:(iterations + 1), [rangeP; rangeF1; rangeF2]);
    xlabel('iterations');
    ylabel('range size');
    title(strcat(['Range size vs. time']));
    legend('P', 'F1', 'F2');

    if p.Results.createFile
        [~, filename, ~] = fileparts(filename);
        filename = fullfile(p.Results.figDir, strcat('range_time_', filename));
        saveas(f, strcat(filename, '.fig'));
        saveas(f, strcat(filename, '.png'));
    end
end
% Range vs. time:1 ends here
