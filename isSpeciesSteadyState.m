function isSteadyState = isSpeciesSteadyState(speed, tolerance)
% takes a matrix of speed values and checks whether the variance in the last 10 values is at or below a threshold

    variance = sqrt(var(speed(end-9:end)));
    if variance <= tolerance
        isSteadyState = true;
    else
        isSteadState = false;
    end
end
