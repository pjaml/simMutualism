% [[file:mutual_ide.org::*3D population density vs. space vs. time plot][3D population density vs. space vs. time plot:1]]
function plotPopSpaceTime(simMatFile, varargin)

    p = inputParser;
    addRequired(p, 'simMatFile');
    addOptional(p,'createFig', true, @islogical);
    addOptional(p, 'figDir', './', @isfolder);

    parse(p, simMatFile, varargin{:});

    filename = simMatFile.filename;
    iterations = simMatFile.iterations;
    nP = simMatFile.nP;
    nF1 = simMatFile.nF1;
    nF2 = simMatFile.nF2;
    nThreshold = simMatFile.nThreshold;
    x = simMatFile.x;

    timeStep = round(iterations / 10);

    %% Figure for species P
    figure(1);
    [xx,tt] = meshgrid(x,0:iterations);
    nlow = nP;
    nlow(nP >= nThreshold) = NaN;
    nP(nP < nThreshold) = NaN;

    rangeP = x(find(nP(end,:) >= nThreshold));

    rangeMin = min(rangeP);
    rangeMax = max(rangeP);

    hold on
    for i = 1:timeStep:iterations
        lineP = plot3(xx(i,:),tt(i,:),nP(i,:),'b', 'LineWidth', 3.0);
        plot3(xx(i,:),tt(i,:),nlow(i,:),'Color',0.8*[1 1 1]);
        grid on
    end
    % plot3(rangeEdgeP(1:11),0:10,nThreshold*ones(1,11),'k');
    axis([(rangeMin - 5) (rangeMax + 5) 0 iterations 0 6.25]);
    xlabel('Spatial range');
    ylabel('Generations');
    zlabel('Population density');
    % title('Species P');
    view(30,30);

    %% Figure for species F1
    [xx,tt] = meshgrid(x,0:iterations);
    nlow = nF1;
    nlow(nF1 >= nThreshold) = NaN;
    nF1(nF1 < nThreshold) = NaN;
    hold on
    for i = 3:timeStep:iterations
        lineF1 = plot3(xx(i,:),tt(i,:),nF1(i,:),'r','LineWidth', 3.0);
        plot3(xx(i,:),tt(i,:),nlow(i,:),'Color',0.8*[1 1 1]);
        grid on
    end

    %% Figure for species F2
    [xx,tt] = meshgrid(x,0:iterations);
    nlow = nF2;
    nlow(nF2 >= nThreshold) = NaN;
    nF2(nF2 < nThreshold) = NaN;
    hold on
    for i = 5:timeStep:iterations
        lineF2 = plot3(xx(i,:),tt(i,:),nF2(i,:),'g', 'LineWidth', 3.0);
        plot3(xx(i,:),tt(i,:),nlow(i,:),'Color',0.8*[1 1 1]);
        grid on
    end
    hold off

    legend([lineP lineF1 lineF2], {'P', 'F_1', 'F_2'});

    if p.Results.createFig
        [~, filename, ~] = fileparts(filename);
        filename = strcat('pop_space_time_', filename, '.fig');
        savefig(strcat(p.Results.figDir, filename));
        clf;
    end
end
% 3D population density vs. space vs. time plot:1 ends here
