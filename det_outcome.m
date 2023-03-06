%% Function to classify outcome of a given simulation
function outcome = det_outcome(nP, nF1, nF2, nThreshold)

    % get the final population densities of P, F1, and F2
    finP = nP(end,:);
    finF1 = nF1(end,:);
    finF2 = nF2(end,:);

    % get the ranges where F1 and F2 populations are above the threshold
    rangeP = find(finP >= nThreshold);
    rangeF1 = find(finF1 >= nThreshold);
    rangeF2 = find(finF2 >= nThreshold);

    max_range = max(length(rangeF1), length(rangeF2));
    % max_range = size(rangeP);

    % if F2 is below the threshold across the total range, then classify as
    % F1 dominance
    if isempty(rangeF2)
        outcome = 1; % F1 dominance

    % if F1 is below the threshold across the total range, then classify as
    % F2 dominance
    elseif isempty(rangeF1)
        outcome = 2; % F2 dominance

    % elseif length(rangeF1)/max_range >= 0.95 & length(rangeF2)/max_range >= 0.95

    % find the range of values in rangeF1 or rangeF2 but not both
    % if the proportion of this range over the total range is less than
    % the arbitrary value 0.05, we call it local coexistence
    elseif length(setxor(rangeF1, rangeF2))/max_range < 0.05
        outcome = 3; % Local coexistence

    % if F1 is above threshold and F2 is below threshold or F2 is above
    % threshold and F1 is below threshold

    % elseif isempty(find(finF2(setxor(rangeF1, rangeF2)) >= nThreshold))

    % we find at least some F1 dominance
    elseif not(isempty(intersect(rangeF1, setxor(rangeF1, rangeF2))))

        % we find at least some F2 dominance
        if not(isempty(intersect(rangeF2, setxor(rangeF1, rangeF2))))
            outcome = 6; % regional coexistence

        % no F2 dominance
        else
            outcome = 4; % Local coexistence + F1 dominance
        end

    elseif not(isempty(intersect(rangeF2, setxor(rangeF1, rangeF2))))
        outcome = 5; % Local coexistence + F2 dominance

    else
        outcome = 7; % unknown
    end
end
