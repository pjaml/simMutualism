% [[file:mutual_ide.org::*Sweep outcomes plot][Sweep outcomes plot:1]]
function plotOutcomes(sweepDir, varargin)

    p = inputParser;

    addRequired(p, 'sweepDir', @isfolder);
    addParameter(p, 'tau12Range', 0.0:0.01:0.40);
    addParameter(p, 'tau21Range', 0.0:0.01:0.40);
    addParameter(p, 'figDir', './', @isfolder);
    parse(p, sweepDir, varargin{:});

    tau12Range = p.Results.tau12Range;
    tau21Range = p.Results.tau21Range;
    figDir = p.Results.figDir;

    outcomes = zeros(length(tau12Range), length(tau21Range));

    files = dir(fullfile(sweepDir, '*.mat'));

    for file = 1:length(files)

        curFile = matfile(fullfile(sweepDir, files(file).name));

        parameters = curFile.parameters;
        % get the values of tau12 and tau21
        tau12 = parameters{find(strcmp('tau12', parameters)) + 1};
        tau21 = parameters{find(strcmp('tau21', parameters)) + 1};

        disp(strcat("The outcome of tau12 = ", num2str(tau12, "%.2f"), " and tau21 = ", num2str(tau21, "%.2f"), " is ", num2str(curFile.outcome)));

        % You can't use == for comparison of floating point numbers, you have to
        % use this ismembertol function The default tolerance is fine for this
        % purpose.
        outcomes(ismembertol(tau12Range, tau12), ismembertol(tau21Range, tau21)) = curFile.outcome;

        clear curFile;

    end
    % F1 dominance, F2 dominance, local coex., local co + F1, local co + F2, regional coexist.
    cmap = [1, 1, 1; 0.1, 0.12, 0.14; 0.2 0.2 0.7; 0.6 0.8 0.3; 0.8 0.0 0.0; 0.1,0.6,0.8];

    f = figure('visible', 'off');
    f.Position = [1 1 996 996];
    h = image(tau12Range, fliplr(tau21Range), rot90(outcomes));%,'ColorScaling', 'scaled','CellLabelColor','none', 'GridVisible','off','ColorbarVisible','on');
    colormap(cmap)
    axis tight
    set(gca,'YDir','normal')
    %set(h, 'EdgeColor', 'none');	
    %h.EdgeColor = [0.94 0.94 0.94];

    %hack to create a legend
    for ii = 1:size(cmap,1)
        ppatch(ii) = patch(NaN, NaN, cmap(ii,:));
    end

    labels = {'F_1 dominance', 'F_2 dominance', 'Local coexistence', 'Local coexistence with F_1 dominance', 'Local coexistence with F_2 dominance', 'Regional coexistence'};

    legend(ppatch, labels, 'Location', 'northeast', 'FontSize', 11);
    xlabel('F_2 competitive ability (\tau_{12})');
    ylabel('F_1 competitive ability (\tau_{21})');
    filename = fullfile(figDir, 'tauSweepOutcomesPlot');
    saveas(f, strcat(filename, '.fig'));
    saveas(f, strcat(filename, '.png'));

end
% Sweep outcomes plot:1 ends here
