% [[file:mutual_ide.org::*Final population densities across space plot][Final population densities across space plot:1]]
function plotFinalPopSpace(simMatFile, varargin)

    p = inputParser;
    addRequired(p, 'simMatFile');
    addOptional(p,'createFile', true, @islogical);
    addOptional(p, 'figDir', './', @isfolder);

    parse(p, simMatFile, varargin{:});

    diameter = simMatFile.diameter;
    nP = simMatFile.nP;
    nF1 = simMatFile.nF1;
    nF2 = simMatFile.nF2;
    nThreshold = simMatFile.nThreshold
    x = simMatFile.x;

    iterations = simMatFile.iterations;
    filename = simMatFile.filename;

    if p.Results.createFile
        f = figure('visible', 'off');
    else
        figure(1);
    end

    rangeP = find(nP(iterations,:) >= nThreshold);

    rangeMin = min(rangeP);
    rangeMax = max(rangeP);

    f.Position = [1 1 996 996];
    axis square;

    hold on
    plot(nP(iterations,:), LineWidth=1.5);
    plot(nF1(iterations,:), LineWidth=1.5);
    plot(nF2(iterations,:), LineWidth=1.5);
    xlim([(rangeMin - 1000) (rangeMax + 1000)]);
    % xticks([(rangeMin - 1000) ((rangeMin - 1000) * 2) (rangeMax + 1000)]);
    xlabel('Spatial range');
    ylabel('Population density');
    xticks([(rangeMin - 1000) (width(nP)/2) (rangeMax + 1000)]);
    xticklabels({num2str(int32(diameter*2/width(nP)*(rangeMin - 1000) - diameter)), '0', num2str(int32(diameter*2/width(nP)*(rangeMax + 1000) - diameter))});

    legend('P', 'F1', 'F2');
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
