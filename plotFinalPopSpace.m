% [[file:mutual_ide.org::*Final population densities across space plot][Final population densities across space plot:1]]
function plotFinalPopSpace(simMatFile, varargin)

    p = inputParser;
    addRequired(p, 'simMatFile');
    addOptional(p,'createFile', true, @islogical);
    addOptional(p, 'figDir', './', @isfolder);

    parse(p, simMatFile, varargin{:});

    nP = simMatFile.nP;
    nF1 = simMatFile.nF1;
    nF2 = simMatFile.nF2;
    iterations = simMatFile.iterations;
    filename = simMatFile.filename;

    if p.Results.createFile
        f = figure('visible', 'off');
    else
        figure(1);
    end

    hold on
    plot(nP(iterations,:));
    plot(nF1(iterations,:));
    plot(nF2(iterations,:));
    legend('P', 'F1', 'F2');
    title(strcat(['N vs. x']));
    hold off

    if p.Results.createFile
        [~, filename, ~] = fileparts(filename);
        filename = fullfile(p.Results.figDir, strcat('final_pop_space_', filename));
        saveas(f, strcat(filename, '.fig'));
        saveas(f, strcat(filename, '.png'));
        clf;
    end
end
% Final population densities across space plot:1 ends here
