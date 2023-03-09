% [[file:mutual_ide.org::*Final population densities across space][Final population densities across space:1]]
function plotFinalPopSpace(simMatFile, varargin)

    p = inputParser;
    addRequired(p, 'simMatFile', @isfile);
    addOptional(p,'createFig', true, @islogical);
    addOptional(p, 'figDir', './', @isfolder);

    parse(p, simMatFile, varargin{:});

    curFile = load(simMatFile, 'nP', 'nF1', 'nF2', 'iterations', 'filename');

    iterations = curFile.iterations;

    hold on
    plot(curFile.nP(iterations + 1,:));
    plot(curFile.nF1(iterations + 1,:));
    plot(curFile.nF2(iterations + 1,:));
    legend('P', 'F1', 'F2');
    title(strcat(['N vs. x']));
    hold off

    if p.Results.createFig
        [~, filename, ~] = fileparts(curFile.filename);
        filename = strcat('final_pop_space_', filename, '.fig');
        savefig(strcat(p.Results.figDir, filename));
    end
    clf;
    clear curFile;
end
% Final population densities across space:1 ends here
