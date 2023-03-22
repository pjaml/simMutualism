% [[file:mutual_ide.org::*Generate figures from paper][Generate figures from paper:1]]
sweepDir = '~/tauSweep/';
figDir = '~/figures/';
formatSpec = '%.2f';

mkdir(figDir)

% tau12 and tau21 pairs
taus = [0 0; 0.05 0; 0.05 0.05; 0.05 0.10; 0.15 0.05; 0.20 0.05; 0.20 0.15; 0.25 0.05; 0.23 0.37; 0.26 0.37; 0.35 0.37];


for i = 1:length(taus)

    % probably a better way to do this with regexp
    targetFile = dir(fullfile(sweepDir, strcat("*tau12_", num2str(taus(i, 1), formatSpec), "*tau21_", num2str(taus(i, 2), formatSpec), "*.mat")));

    filename = fullfile(sweepDir, targetFile.name);

    curFile = load(filename, 'iterations', 'filename', 'nP', 'nF1', 'nF2', 'nThreshold', 'x', 'instantSpeedP', 'instantSpeedF1', 'instantSpeedF2');

    plotPopSpaceTime(curFile, 'figDir', figDir);

    plotFinalPopSpace(curFile, 'figDir', figDir);

    plotSpeedTime(curFile, 'figDir', figDir);

    clear curFile;
end

% get the heatmap of all the outcomes
disp('Generating outcomes plot...')
plotOutcomes(sweepDir, 'figDir', figDir);

% also save plots as PNGs
figs = dir(fullfile(figDir, '*.fig'));
for file = 1:length(figs)
    curFig = openfig(fullfile(figDir, figs(file).name));
    [~, filename, ~] = fileparts(figs(file).name);
    filename = strcat(figDir, filename, ".png");
    saveas(curFig, filename);
    close(curFig);
end
% Generate figures from paper:1 ends here
