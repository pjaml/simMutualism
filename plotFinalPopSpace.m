function plotFinalPopSpace(simMatFile, varargin)

    p = inputParser;
    addRequired(p, 'simMatFile', @isfile);
    addOptional(p,'createFile', false, @islogical);
    addOptional(p, 'imgDir', './', @isfolder);

    parse(p, simMatFile, varargin{:});

    load(simMatFile, 'nP', 'nF1', 'nF2');

    clf
    hold on
    plot(nP(end,:));
    plot(nF1(end,:));
    plot(nF2(end,:));
    legend('P', 'F1', 'F2');
    title(strcat(['N vs. x']));
    hold off

    if p.Results.createFile
        filename = strcat('final_pop_space_', filename, '.fig');
        savefig(strcat(imgDir, filename));
    end
end
