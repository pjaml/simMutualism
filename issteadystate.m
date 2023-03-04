function steadystate = issteadystate(speed, tolerance)
% takes a matrix of speed values and checks whether the variance in the last 10 values is at or below a threshold

    variance = sqrt(var(speed(end-9:end)));
    if variance <= tolerance
        steadystate = true;
    else
        steadstate = false;
    end

end
