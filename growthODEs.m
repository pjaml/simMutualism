% [[file:mutual_ide.org::*Function definition][Function definition:1]]
function dydt = growthODEs(t, y, varargin)
% Function definition:1 ends here

% [[file:mutual_ide.org::*Default parameter values][Default parameter values:1]]
    %% Default ODE parameter values

    default_nodes = (2^16) + 1;

    % intrinsic growth
    default_rP = 0.4;
    default_rF1 = 0.3;
    default_rF2 = 0.3;

    % mutualism benefits
    default_alphaPF1 = 0.5;
    default_alphaPF2 = 0.5;
    default_alphaF1P = 0.5;
    default_alphaF2P = 0.5;

    default_qP = 1.0;
    default_qF1 = 1.0;
    default_qF2 = 1.0;

    % mutualism costs
    default_betaP = 0.0;
    default_betaF1 = 0.0;
    default_betaF2 = 0.0;

    default_cP = 1.0;
    default_cF1 = 1.0;
    default_cF2 = 1.0;

    % death rate
    default_dP = 0.1;
    default_dF1 = 0.1;
    default_dF2 = 0.1;

    % saturation
    default_hPF1 = 0.3;
    default_hPF2 = 0.3;
    default_hF1P = 0.3;
    default_hF2P = 0.3;

    default_eP = 0.3;
    default_eF1 = 0.3;
    default_eF2 = 0.3;

    % = 0.0;
    default_deltaP = 0.1;
    default_deltaF1 = 0.9;
    default_deltaF2 = 0.1;

    % competition: tau12 is the effect F2 has on F1; tau21 is effect of F1 on F2
    default_tau12 = 0.0;
    default_tau21 = 0.0;
% Default parameter values:1 ends here

% [[file:mutual_ide.org::*Adding parameters with =inputParser=][Adding parameters with =inputParser=:1]]
    p = inputParser;
    p.KeepUnmatched = true;

    addRequired(p, 't');
    addRequired(p, 'y');

    %% Optional ODE parameters

    addParameter(p, 'nodes', default_nodes);

    % intrinsic growth rates
    addParameter(p, 'rP', default_rP);
    addParameter(p, 'rF1', default_rF1);
    addParameter(p, 'rF2', default_rF2);

    % mutualism benefits
    addParameter(p, 'alphaPF1', default_alphaPF1);
    addParameter(p, 'alphaPF2', default_alphaPF2);
    addParameter(p, 'alphaF1P', default_alphaF1P);
    addParameter(p, 'alphaF2P', default_alphaF2P);

    addParameter(p, 'qP', default_qP );
    addParameter(p, 'qF1', default_qF1);
    addParameter(p, 'qF2', default_qF2);

    % mutualism costs
    addParameter(p, 'betaP', default_betaP);
    addParameter(p, 'betaF1', default_betaF1);
    addParameter(p, 'betaF2', default_betaF2);

    addParameter(p, 'cP', default_cP);
    addParameter(p, 'cF1', default_cF1);
    addParameter(p, 'cF2', default_cF2);

    % death rate
    addParameter(p, 'dP', default_dP);
    addParameter(p, 'dF1', default_dF1);
    addParameter(p, 'dF2', default_dF2);

    % saturation
    addParameter(p, 'hPF1', default_hPF1);
    addParameter(p, 'hPF2', default_hPF2);
    addParameter(p, 'hF1P', default_hF1P);
    addParameter(p, 'hF2P', default_hF2P);

    addParameter(p, 'eP', default_eP);
    addParameter(p, 'eF1', default_eF1);
    addParameter(p, 'eF2', default_eF2);

    % mutualism dependence
    addParameter(p, 'deltaP', default_deltaP);
    addParameter(p, 'deltaF1', default_deltaF1);
    addParameter(p, 'deltaF2', default_deltaF2);

    % competition
    addParameter(p, 'tau12', default_tau12);
    addParameter(p, 'tau21', default_tau21);

    parse(p, t, y, varargin{:});

    % relabel variables so they're easier to read in the equation

    t = p.Results.t;
    y = p.Results.y;
    nodes = p.Results.nodes;

    % intrinsic growth
    rP = p.Results.rP;
    rF1 = p.Results.rF1;
    rF2 = p.Results.rF2;

    % mutualism benefits
    alphaPF1 = p.Results.alphaPF1;
    alphaPF2 = p.Results.alphaPF2;
    alphaF1P = p.Results.alphaF1P;
    alphaF2P = p.Results.alphaF2P;

    qP = p.Results.qP;
    qF1 = p.Results.qF1;
    qF2 = p.Results.qF2;

    % mutualism costs
    betaP = p.Results.betaP;
    betaF1 = p.Results.betaF1;
    betaF2 = p.Results.betaF2;

    cP = p.Results.cP;
    cF1 = p.Results.cF1;
    cF2 = p.Results.cF2;

    % death rate
    dP = p.Results.dP;
    dF1 = p.Results.dF1;
    dF2 = p.Results.dF2;

    % saturation
    hPF1 = p.Results.hPF1;
    hPF2 = p.Results.hPF2;
    hF1P = p.Results.hF1P;
    hF2P = p.Results.hF2P;

    eP = p.Results.eP;
    eF1 = p.Results.eF1;
    eF2 = p.Results.eF2;

    % mutualism dependence
    deltaP = p.Results.deltaP;
    deltaF1 = p.Results.deltaF1;
    deltaF2 = p.Results.deltaF2;

    % competition: tau12 is the effect F2 has on F1; tau21 is effect of F1 on F2
    tau12 = p.Results.tau12;
    tau21 = p.Results.tau21;

    y = reshape(y,3,nodes);
    dydt  = zeros(size(y));
% Adding parameters with =inputParser=:1 ends here

% [[file:mutual_ide.org::*Species /P/][Species /P/:2]]
    % rename variables so equations are easier to read
    P = y(1,:);
    F1 = y(2,:);
    F2 = y(3,:);

    dydt(1,:) = P .* ((1 - deltaP) * rP + deltaP * (cP * (alphaPF1 .* F1 ./ (hPF1 + F1) + alphaPF2 .* F2 ./ (hPF2 + F2))) - deltaF1 * (qP * (betaP .* F1 ./ (eP + P))) - deltaF2 * (qP * (betaP .* F2 ./ (eP + P))) - dP .* P);
% Species /P/:2 ends here

% [[file:mutual_ide.org::*Species /F/, Phenotype 1][Species /F/, Phenotype 1:2]]
    dydt(2,:) = F1 .* ((1 - deltaF1) * rF1 + deltaF1 * (cF1 * (alphaF1P .* P) ./ (hF1P + P)) - qF1 * (deltaP * ((betaF1 .* P) ./ (eF1 + F1))) - (tau12 .* F2) - dF1 .* F1);
% Species /F/, Phenotype 1:2 ends here

% [[file:mutual_ide.org::*Species /F/, Phenotype 2][Species /F/, Phenotype 2:2]]
    dydt(3,:) = F2 .* ((1 - deltaF2) * rF2 + deltaF2 * (cF2 * (alphaF2P .* P) ./ (hF2P + P)) - qF2 * (deltaP * ((betaF2 .* P) ./ (eF2 + F2))) - (tau21 .* F1) - dF2 .* F2);
% Species /F/, Phenotype 2:2 ends here

% [[file:mutual_ide.org::*Reshape][Reshape:1]]
    dydt = reshape(dydt,3*nodes,1);
end
% Reshape:1 ends here
