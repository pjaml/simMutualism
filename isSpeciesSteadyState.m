function isSteadyState = isSpeciesSteadyState(speed, tolerance, interation)
% takes a matrix of speed values and checks whether the variance in the last 10 values is at or below a threshold

    variance = sqrt(var(speed(iteration-9:iteration)));
    if variance <= tolerance
        isSteadyState = true;
    else
        isSteadState = false;
    end
end
