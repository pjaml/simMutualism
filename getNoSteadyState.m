% [[file:mutual_ide.org::*Which simulations never reached a steady state?][Which simulations never reached a steady state?:1]]
function getNoSteadyState(sweepDir)

    files = dir(fullfile(sweepDir, '*.mat'));

    for file = 1:length(files)
        curFile = matfile(fullfile(sweepDir, files(file).name));

        parameters = curFile.parameters;

        % get the values of tau12 and tau21
        tau12 = parameters{find(strcmp('tau12', parameters)) + 1};
        tau21 = parameters{find(strcmp('tau21', parameters)) + 1};

        if curFile.iterations == curFile.maxIterations
            disp(strcat("The simulation of tau12 = ", num2str(tau12, "%.2f"), " and tau21 = ", num2str(tau21, "%.2f"), "reached the maxIterations value of ", num2str(maxIterations)));
        end
    end
end
% Which simulations never reached a steady state?:1 ends here
