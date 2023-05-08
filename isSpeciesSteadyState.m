% [[file:mutual_ide.org::*Checking if a species is at a steady state][Checking if a species is at a steady state:1]]
function isSteadyState = isSpeciesSteadyState(speed, tolerance, generation)
% takes a matrix of speed values and checks whether the variance in the last 5 values is at or below a threshold

    variance = sqrt(var(speed((generation - 4):generation)));

    if variance <= tolerance
        isSteadyState = true;
    else
        isSteadyState = false;
    end
end
% Checking if a species is at a steady state:1 ends here
