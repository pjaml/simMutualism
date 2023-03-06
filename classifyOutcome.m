%% Function to classify outcome of a given simulation
function outcome = classifyOutcome(finalNF1, finalNF2, nThreshold);

    % get the ranges where F1 and F2 populations are above the threshold
    rangeF1 = find(finalNF1 >= nThreshold);
    rangeF2 = find(finalNF2 >= nThreshold);

    maxRange = max(length(rangeF1), length(rangeF2));

    if length(rangeF1) == maxRange
        isF1Dominant = true;
    else
        isF1Dominant = false;
    end

    % maxRange = size(rangeP);

    % if F2 is below the threshold across the total range, then classify as
    % F1 dominance
    if isempty(rangeF2)
        outcome = 1; % F1 dominance

    % if F1 is below the threshold across the total range, then classify as
    % F2 dominance
    elseif isempty(rangeF1)
        outcome = 2; % F2 dominance

    % find the range of values in rangeF1 or rangeF2 but not both
    % if the proportion of this range over the total range is less than
    % the arbitrary value 0.05, we call it local coexistence
    elseif length(setxor(rangeF1, rangeF2))/maxRange < 0.05
        outcome = 3; % Local coexistence

    elseif length(rangeF1) > length(rangeF2)

        % we find at least some F2 dominance
        if intersect(rangeF2, setxor(rangeF1, rangeF2))
            outcome = 6; % regional coexistence

        % no F2 dominance
        else
            outcome = 4; % Local coexistence + F1 dominance
        end

    elseif length(rangeF2) > length(rangeF1)

        % we find at least some F1 dominance
        if intersect(rangeF1, setxor(rangeF1, rangeF2))
            outcome = 6; % regional coexistence
        else
            outcome = 5; % Local coexistence + F2 dominance
        end
    else
        outcome = 7; % unknown
    end
end
