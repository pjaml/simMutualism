% [[file:mutual_ide.org::*Generate plots for paper][Generate plots for paper:1]]
sweepDir = '~/tauSweep/';
figDir = '~/figures/';
formatSpec = '%.2f';

% tau12 and tau21 pairs
taus = [0 0; 0.05 0; 0.05 0.05; 0.05 0.10; 0.15 0.05; 0.20 0.05; 0.20 0.15; 0.25 0.05; 0.23 0.37; 0.26 0.37; 0.35 0.37];

for i = 1:length(taus)
    filename = strcat(sweepDir, "results_tau12_", num2str(taus(i, 1), formatSpec), "_tau21_", num2str(taus(i, 2), formatSpec), ".mat");

    plotPopSpaceTime(filename, 'figDir', figDir);

    plotFinalPopSpace(filename, 'figDir', figDir);

    plotSpeedTime(filename, 'figDir', figDir);
end

% get the heatmap of all the outcomes
disp('Generating outcomes plot...')
plotOutcomes(sweepDir, 'figDir', figDir);

% also save plots as PNGs
figs = dir(fullfile(figDir, '*.fig'));
for file = 1:length(figs)
    curFig = openfig(fullfile(figDir, figs(file)));
    [~, filename, ~] = fileparts(figs(file));
    filename = strcat(figDir, filename, ".png");
    saveas(curFig, filename);
    close(curFig);
end
% Generate plots for paper:1 ends here
