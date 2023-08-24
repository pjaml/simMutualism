% [[file:mutual_ide.org::*Function to classify outcome (=classifyOutcome.m=)][Function to classify outcome (=classifyOutcome.m=):1]]
%% Function to classify outcome of a given simulation
function [rangeF1size, rangeF2size,rho] = classifyOutcome_fig5(finalNF1, finalNF2, nThreshold)

    % get the ranges where F1 and F2 populations are above the threshold
    rangeF1 = find(finalNF1 >= nThreshold);
    rangeF2 = find(finalNF2 >= nThreshold);
    rangeF1size = length(rangeF1);
    rangeF2size = length(rangeF2);

    lenMaxRange = max(length(rangeF1), length(rangeF2));
    union_range = union(rangeF1,rangeF2);

    % range where one species exists but not the other
    %exclusiveRange = setxor(rangeF1, rangeF2);
    rho = (length(rangeF1) - length(rangeF2))/length(union_range);
end
