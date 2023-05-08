% [[file:mutual_ide.org::*Function to classify outcome (=classifyOutcome.m=)][Function to classify outcome (=classifyOutcome.m=):1]]
%% Function to classify outcome of a given simulation
function outcome = classifyOutcome(finalNF1, finalNF2, nThreshold)

    % get the ranges where F1 and F2 populations are above the threshold
    rangeF1 = find(finalNF1 >= nThreshold);
    rangeF2 = find(finalNF2 >= nThreshold);

    lenMaxRange = max(length(rangeF1), length(rangeF2));

    % range where one species exists but not the other
    exclusiveRange = setxor(rangeF1, rangeF2);
% Function to classify outcome (=classifyOutcome.m=):1 ends here

% [[file:mutual_ide.org::*Function to classify outcome (=classifyOutcome.m=)][Function to classify outcome (=classifyOutcome.m=):2]]
    % if F2 is below the threshold across the total range, then classify as
    % F1 dominance
    if isempty(rangeF2)
        outcome = 1; % F1 dominance

    % if F1 is below the threshold across the total range, then classify as
    % F2 dominance
    elseif isempty(rangeF1)
        outcome = 2; % F2 dominance
% Function to classify outcome (=classifyOutcome.m=):2 ends here

% [[file:mutual_ide.org::*Function to classify outcome (=classifyOutcome.m=)][Function to classify outcome (=classifyOutcome.m=):3]]
    % find the range of values in rangeF1 or rangeF2 but not both
    % if the proportion of this range over the total range is less than
    % the arbitrary value 0.05, we call it local coexistence
    elseif length(exclusiveRange)/lenMaxRange < 0.05
        outcome = 3; % Local coexistence
% Function to classify outcome (=classifyOutcome.m=):3 ends here

% [[file:mutual_ide.org::*Function to classify outcome (=classifyOutcome.m=)][Function to classify outcome (=classifyOutcome.m=):4]]
    elseif length(rangeF1) > length(rangeF2)

        % no F2 dominance
        if isempty(intersect(rangeF2, exclusiveRange))
            outcome = 4; % Local coexistence + F1 dominance
        % we find at least some F2 dominance
        else
            outcome = 6; % regional coexistence
        end

    elseif length(rangeF2) > length(rangeF1)

        % no F1 dominance
        if isempty(intersect(rangeF1, exclusiveRange))
            outcome = 5; % Local coexistence + F2 dominance
        else
            % we find at least some F1 dominance
            outcome = 6; % regional coexistence
        end
    else
        outcome = 7; % unknown
    end
end
% Function to classify outcome (=classifyOutcome.m=):4 ends here
