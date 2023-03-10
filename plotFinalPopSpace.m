% [[file:mutual_ide.org::*Final population densities across space][Final population densities across space:1]]
function plotFinalPopSpace(simMatFile, varargin)

    p = inputParser;
    addRequired(p, 'simMatFile');
    addOptional(p,'createFig', true, @islogical);
    addOptional(p, 'figDir', './', @isfolder);

    parse(p, simMatFile, varargin{:});

    nP = simMatFile.nP;
    nF1 = simMatFile.nF1;
    nF2 = simMatFile.nF2;
    iterations = simMatFile.iterations;
    filename = simMatFile.filename;

    hold on
    plot(nP(iterations + 1,:));
    plot(nF1(iterations + 1,:));
    plot(nF2(iterations + 1,:));
    legend('P', 'F1', 'F2');
    title(strcat(['N vs. x']));
    hold off

    if p.Results.createFig
        [~, filename, ~] = fileparts(filename);
        filename = strcat('final_pop_space_', filename, '.fig');
        savefig(strcat(p.Results.figDir, filename));
    end
    clf;
end
% Final population densities across space:1 ends here
