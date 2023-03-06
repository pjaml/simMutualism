% function dydt = growthODEs(t, y, r1, r2, alpha12, alpha21, q1, q2, beta1, beta2, c1, c2, d1, d2, h1, h2,e1, e2, nodes, dep_p, dep_f, comp_12, comp_21)
function dydt = growthODEs(t, y, varargin)

    %% Default ODE parameter values

    default_nodes = (2^16) + 1;

    % intrinsic growth
    default_r_p = 0.3;
    default_r_f1 = 0.3;
    default_r_f2 = 0.3;

    % mutualism benefits
    default_alpha_p_f1 = 0.5;
    default_alpha_p_f2 = 0.5;
    default_alpha_f1_p = 0.5;
    default_alpha_f2_p = 0.5;

    default_q_p = 1.0;
    default_q_f1 = 1.0;
    default_q_f2 = 1.0;

    % mutualism costs
    default_beta_p = 0.0;
    default_beta_f1 = 0.0;
    default_beta_f2 = 0.0;

    default_c_p = 1.0;
    default_c_f1 = 1.0;
    default_c_f2 = 1.0;

    % death rate
    default_d_p = 0.1;
    default_d_f1 = 0.1;
    default_d_f2 = 0.1;

    % saturation
    default_h_p_f1 = 0.3;
    default_h_p_f2 = 0.3;
    default_h_f1_p = 0.3;
    default_h_f2_p = 0.3;

    default_e_p = 0.3;
    default_e_f1 = 0.3;
    default_e_f2 = 0.3;

    % = 0.0;
    default_delta_p = 0.0;
    default_delta_f1 = 0.9;
    default_delta_f2 = 0.1;

    % competition: tau_12 is the effect F2 has on F1; tau_21 is effect of F1 on F2
    default_tau_12 = 0.0;
    default_tau_21 = 0.0;

    p = inputParser;
    p.KeepUnmatched = true;

    addRequired(p, 't');
    addRequired(p, 'y');

    %% Optional ODE parameters

    addParameter(p, 'nodes', default_nodes);

    % intrinsic growth rates
    addParameter(p, 'r_p', default_r_p);
    addParameter(p, 'r_f1', default_r_f1);
    addParameter(p, 'r_f2', default_r_f2);

    % mutualism benefits
    addParameter(p, 'alpha_p_f1', default_alpha_p_f1);
    addParameter(p, 'alpha_p_f2', default_alpha_p_f2);
    addParameter(p, 'alpha_f1_p', default_alpha_f1_p);
    addParameter(p, 'alpha_f2_p', default_alpha_f2_p);

    addParameter(p, 'q_p', default_q_p );
    addParameter(p, 'q_f1', default_q_f1);
    addParameter(p, 'q_f2', default_q_f2);

    % mutualism costs
    addParameter(p, 'beta_p', default_beta_p);
    addParameter(p, 'beta_f1', default_beta_f1);
    addParameter(p, 'beta_f2', default_beta_f2);

    addParameter(p, 'c_p', default_c_p);
    addParameter(p, 'c_f1', default_c_f1);
    addParameter(p, 'c_f2', default_c_f2);

    % death rate
    addParameter(p, 'd_p', default_d_p);
    addParameter(p, 'd_f1', default_d_f1);
    addParameter(p, 'd_f2', default_d_f2);

    % saturation
    addParameter(p, 'h_p_f1', default_h_p_f1);
    addParameter(p, 'h_p_f2', default_h_p_f2);
    addParameter(p, 'h_f1_p', default_h_f1_p);
    addParameter(p, 'h_f2_p', default_h_f2_p);

    addParameter(p, 'e_p', default_e_p);
    addParameter(p, 'e_f1', default_e_f1);
    addParameter(p, 'e_f2', default_e_f2);

    % mutualism dependence
    addParameter(p, 'delta_p', default_delta_p);
    addParameter(p, 'delta_f1', default_delta_f1);
    addParameter(p, 'delta_f2', default_delta_f2);

    % competition
    addParameter(p, 'tau_12', default_tau_12);
    addParameter(p, 'tau_21', default_tau_21);

    parse(p, t, y, varargin{:});

    % relabel variables so they're easier to read in the equation

    t = p.Results.t;
    y = p.Results.y;
    nodes = p.Results.nodes;

    % intrinsic growth
    r_p = p.Results.r_p;
    r_f1 = p.Results.r_f1;
    r_f2 = p.Results.r_f2;

    % mutualism benefits
    alpha_p_f1 = p.Results.alpha_p_f1;
    alpha_p_f2 = p.Results.alpha_p_f2;
    alpha_f1_p = p.Results.alpha_f1_p;
    alpha_f2_p = p.Results.alpha_f2_p;

    q_p = p.Results.q_p;
    q_f1 = p.Results.q_f1;
    q_f2 = p.Results.q_f2;

    % mutualism costs
    beta_p = p.Results.beta_p;
    beta_f1 = p.Results.beta_f1;
    beta_f2 = p.Results.beta_f2;

    c_p = p.Results.c_p;
    c_f1 = p.Results.c_f1;
    c_f2 = p.Results.c_f2;

    % death rate
    d_p = p.Results.d_p;
    d_f1 = p.Results.d_f1;
    d_f2 = p.Results.d_f2;

    % saturation
    h_p_f1 = p.Results.h_p_f1;
    h_p_f2 = p.Results.h_p_f2;
    h_f1_p = p.Results.h_f1_p;
    h_f2_p = p.Results.h_f2_p;

    e_p = p.Results.e_p;
    e_f1 = p.Results.e_f1;
    e_f2 = p.Results.e_f2;

    % mutualism dependence
    delta_p = p.Results.delta_p;
    delta_f1 = p.Results.delta_f1;
    delta_f2 = p.Results.delta_f2;

    % competition: tau_12 is the effect F2 has on F1; tau_21 is effect of F1 on F2
    tau_12 = p.Results.tau_12;
    tau_21 = p.Results.tau_21;

    y = reshape(y,3,nodes);
    dydt  = zeros(size(y));

    % rename variables so equations are easier to read
    P = y(1,:);
    F1 = y(2,:);
    F2 = y(3,:);

    dydt(1,:) = P .* ((1 - delta_p) * r_p + delta_p * (c_p * ((alpha_p_f1 .* F1) ./ (h_p_f1 + F1) + (alpha_p_f2 .* F2) ./ (h_p_f2 + F2))) - delta_f1 * (q_p * (beta_p .* F1 ./ (e_p + P))) - delta_f2 * (q_p * (beta_p .* F2 ./ (e_p + P))) - (d_p .* P));

    dydt(2,:) = F1 .* ((1 - delta_f1) * r_f1 + c_f1 * (delta_f1 * (alpha_f1_p .* P) ./ (h_f1_p + P)) - q_f1 * (delta_p * ((beta_f1 .* P) ./ (e_f1 + F1))) - (tau_12 .* F2) - (d_f1 .* F1));

    dydt(3,:) = F2 .* ((1 - delta_f2) * r_f2 + c_f2 * (delta_f2 * (alpha_f2_p .* P) ./ (h_f2_p + P)) - q_f2 * (delta_p * ((beta_f2 .* P) ./ (e_f2 + F2))) - (tau_21 .* F1) - (d_f2 .* F2));

    dydt = reshape(dydt,3*nodes,1);
end
