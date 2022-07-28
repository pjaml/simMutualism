%% Function to classify outcome of a given simulation
function outcome = det_outcome(n_F1, n_F2, ncrit)

    % get the final population densities of P, F1, and F2
    fin_F1 = n_F1(end,:);
    fin_F2 = n_F2(end,:);

    % get the ranges where F1 and F2 populations are above the threshold
    rangeF1 = find(fin_F1 >= ncrit);
    rangeF2 = find(fin_F2 >= ncrit);

    max_range = max(size(rangeF1), size(rangeF2));

    % if F2 is below the threshold across the total range, then classify as
    % F1 dominance
    if isempty(rangeF2)
        outcome = 1; % F1 dominance

    % if F1 is below the threshold across the total range, then classify as
    % F2 dominance
    elseif isempty(rangeF1)
        outcome = 2; % F2 dominance

    elseif abs(size(rangeF1)/max_range - (size(rangeF2)/max_range)) >= 0.95
        outcome = 3; % Local coexistence

    % if F1 is above threshold and F2 is below threshold or F2 is above
    % threshold and F1 is below threshold
    elseif isempty(find(fin_F2(setxor(rangeF1, rangeF2)) >= ncrit))
        outcome = 4; % Local coexistence + F1 dominance

    elseif isempty(find(fin_F1(setxor(rangeF1, rangeF2)) >= ncrit))
        outcome = 5; % Local coexistence + F2 dominance

    else
        outcome = 6; % regional coexistence
    end
end
