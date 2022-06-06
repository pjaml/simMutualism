% Equations for consumer-resource bi-directional mutualism as described in Holland et al. 2010.
function dN = cr_mutualism(t, n1, n2, r, c, a, h, q, b, e, d)

    dN1 = n1 .* (r(1) + c(1) .* (a(1) .* n2 ./ (h(2) + n2)) - q(1) .* (b(1) .* n2 ./ (e(1) + n1)) - d(1) .* n1);

    dN2 = n2 .* (r(2) + c(2) .* (a(2) .* n1 ./ (h(1) + n1)) - q(2) .* (b(2) .* n1 ./ (e(2) + n2)) - d(2) .* n2);

    dN = [dN1; dN2];

end
