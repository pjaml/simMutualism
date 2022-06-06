function dN = lotka(t, n1, n2, r, s)

    % Prey
    dN1 = r(1) .* n1 - s(1) .* n1 .* n2;

    % Predator
    dN2 = r(2) .* n2 + s(2) .* n1 .* n2;

    dN = [dN1; dN2];

end
