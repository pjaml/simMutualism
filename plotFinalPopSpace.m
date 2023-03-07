% [[file:mutual_ide.org::*Final population densities across space][Final population densities across space:1]]
function plotFinalPopSpace(simMatFile, varargin)

    p = inputParser;
    addRequired(p, 'simMatFile', @isfile);
    addOptional(p,'createFile', false, @islogical);
    addOptional(p, 'imgDir', './', @isfolder);

    parse(p, simMatFile, varargin{:});

    load(simMatFile, 'nP', 'nF1', 'nF2', 'iterations', 'filename');

    hold on
    plot(nP(iterations + 1,:));
    plot(nF1(iterations + 1,:));
    plot(nF2(iterations + 1,:));
    legend('P', 'F1', 'F2');
    title(strcat(['N vs. x']));
    hold off

    if p.Results.createFile
        filename = strcat('final_pop_space_', filename, '.fig');
        savefig(strcat(imgDir, filename));
    end
end
% Final population densities across space:1 ends here
