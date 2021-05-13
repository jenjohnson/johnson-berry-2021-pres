function m = model_fun(v)

%% Update input variables

% Rename measured environmental variables to drive simulations
[Q, T, C, O, ...
Abs, beta, CB6F, RUB, Rds, ...
Kf, Kd, Kp1, Kn1, Kp2, Ku2, ...
kq, nl, nc, kc, ko, Kc, Ko, ...
alpha_opt, solve_xcs, ...
theta1, eps1, eps2] = loadvars_fun(v);

% Calculate derived variables
Vqmax = CB6F.*kq;       % Maximum Cyt b6f activity, mol e-1 m-2 s-1
Vcmax = RUB.*kc;        % Maximum Rubisco activity, mol CO2 m-2 s-1
Rd = Vcmax.*Rds;        % Mitochondrial respiration, mol CO2 m-2 s-1
S = (kc./Kc).*(Ko./ko); % Rubisco specificity for CO2/O2, dimensionless
gammas = O./(2.*S);     % CO2 compensation point in the absence of Rd, bar
eta = (1-(nl./nc)+(3+7.*gammas./C)./((4+8.*gammas./C).*nc)); % PS I/II ETR
phi1P_max = Kp1./(Kp1+Kd+Kf); % Maximum photochemical yield PS I

% Establish PSII and PS I cross-sections, mol PPFD abs PS2/PS1 mol-1 PPFD
if strcmp(alpha_opt,"static") == 1
    a2 = Abs.*beta;
    a1 = Abs - a2;        
end 
if strcmp(alpha_opt,"dynamic") == 1
    a2 = solve_xcs(Abs,CB6F,Kd,Kf,Kp2,Ku2,Q,eta,kq,phi1P_max);
    a1 = Abs - a2; 
end


%% Calculate limiting rates for gas-exchange and electron transport

% Expressions for potential Cytochrome b6f-limited rates (_j)
%   N.B., see Eqns. 30-31
JP700_j = (Q.*Vqmax)./(Q+Vqmax./(a1.*phi1P_max));
JP680_j = JP700_j./eta;
Vc_j = JP680_j./(4.*(1+2.*gammas./C));
Vo_j = Vc_j.*2.*gammas./C;
Ag_j = Vc_j - Vo_j./2;

% Expressions for potential Rubisco-limited rates (_c)
%   N.B., see Eqns. 32-33
Vc_c = C.*Vcmax./(C + Kc.*(1+O./Ko));
Vo_c = Vc_c.*2.*gammas./C;
Ag_c = Vc_c - Vo_c./2;
JP680_c = Ag_c.*4.*(1+2.*gammas./C)./(1-gammas./C); 
JP700_c = JP680_c.*eta;

%% Select min of Rubisco-limited and Cyt b6f-limited rates

% Define anonymous function for quadratic to smooth transitions
%   N.B., this returns an array with the two roots of the quadratic
tr = @(l1,l2,th)[((l1+l2)+sqrt((l1+l2).^2-4.*th.*l1.*l2))./(2.*th),...
                 ((l1+l2)-sqrt((l1+l2).^2-4.*th.*l1.*l2))./(2.*th)];

% N.B., min(X,[],2) returns column vector with minimum value of each row;
% these minimum rates are interpreted as the actual rates (_a)

% Select minimum PS1 ETR 
JP700_a = min(tr(JP700_j,JP700_c,theta1),[],2);

% Select minimum PS2 ETR 
JP680_a = min(tr(JP680_j,JP680_c,theta1),[],2);

% Select minimum Ag_a 
Ag_a  = min(tr(Ag_j,Ag_c,theta1),[],2).*logical(C>gammas) + ...
               max(tr(Ag_j,Ag_c,theta1),[],2).*logical(C<=gammas);
An_a = Ag_a - Rd;

%% Derive a2/a1 at light saturation point and update
% N.B., this represents dynamic optimization of a2/a1 under 
% limiting light, and then under saturating light holds a2/a1 at 
% the values attained at the light saturation point.

if strcmp(alpha_opt,"dynamic") == 1
    
    [~,I] = min([JP700_j,JP700_c],[],2);
    which = find(logical(diff(I)), 1, 'last' );
    a2_new = repmat(a2(which),length(a2),1);
    a2_old = a2;
    a2_update = [a2_old( a2_old > a2_new ) ; a2_new( a2_old <= a2_new )];
    a2 = a2_update;
    a1 = Abs-a2;

    clearvars I which a2_new a2_old a2_update;
    
end

%% Derive fluorescence parameters from gas-exchange and electron transport

% Primary fluorescence parameters

CB6F_a = JP700_j./kq;       % Eqns. 21, 30a, 34
phi1P_a = JP700_a./(Q.*a1); % Eqn. 20
q1_a = phi1P_a./phi1P_max;  % Eqn. 19a
phi2P_a = JP680_a./(Q.*a2); % Eqn. 26
q2_a = 1 - CB6F_a./CB6F;    % Eqns. 28 and 34

% N.B., rearrange Eqn. 25a to solve for Kn2_a
Kn2_a = ((Kp2.^2.*phi2P_a.^2 - 2.*Kp2.^2.*phi2P_a.*q2_a + ...
   Kp2.^2.*q2_a.^2 - 4.*Kp2.*Ku2.*phi2P_a.^2.*q2_a + ...
   2.*Kp2.*Ku2.*phi2P_a.^2 + 2.*Kp2.*Ku2.*phi2P_a.*q2_a + ...
   Ku2.^2.*phi2P_a.^2).^(1./2) - Kp2.*phi2P_a + Ku2.*phi2P_a + ...
   Kp2.*q2_a)./(2.*phi2P_a) - Kf - Ku2 - Kd;

% Derived fluorescence parameters -- 'True values'

% Photosystem II (Eqns. 23a-23e and 25a-25d)
phi2p_a = (q2_a).*Kp2./(Kp2 + Kn2_a + Kd + Kf + Ku2);
phi2n_a = (q2_a).*Kn2_a./(Kp2 + Kn2_a + Kd + Kf + Ku2) + ...
    (1 - q2_a).*Kn2_a./(Kn2_a + Kd + Kf + Ku2);
phi2d_a = (q2_a).*Kd./(Kp2 + Kn2_a + Kd + Kf + Ku2) + ...
    (1 - q2_a).*Kd./(Kn2_a + Kd + Kf + Ku2);
phi2f_a = (q2_a).*Kf./(Kp2 + Kn2_a + Kd + Kf + Ku2) + ...
    (1 - q2_a).*Kf./(Kn2_a + Kd + Kf + Ku2);
phi2u_a = (q2_a).*Ku2./(Kp2 + Kn2_a + Kd + Kf + Ku2) + ...
    (1 - q2_a).*Ku2./(Kn2_a + Kd + Kf + Ku2);
phi2P_a = phi2p_a./(1-phi2u_a);
phi2N_a = phi2n_a./(1-phi2u_a);
phi2D_a = phi2d_a./(1-phi2u_a);
phi2F_a = phi2f_a./(1-phi2u_a);

% For Photosystem I (Eqns. 19a-19d)
phi1P_a = (q1_a).*Kp1./(Kp1 + Kd + Kf);
phi1N_a = (1 - q1_a).*Kn1./(Kn1 + Kd + Kf);
phi1D_a = (q1_a).*Kd./(Kp1 + Kd + Kf) + (1 - q1_a).*Kd./(Kn1 + Kd + Kf);
phi1F_a = (q1_a).*Kf./(Kp1 + Kd + Kf) + (1 - q1_a).*Kf./(Kn1 + Kd + Kf);

% Derived fluorescence parameters -- 'Observed values'  

% PAM measured fluorescence levels (Eqns. 38-42)
%   N.B., hardcoding of a2(1) for dark-adapted value
Fm_a = a2(1).*Kf./(Kd + Kf).*eps2 + a1(1).*Kf./(Kn1 + Kd + Kf).*eps1;
Fo_a = a2(1).*Kf./(Kp2 + Kd + Kf).*eps2 + a1(1).*Kf./(Kp1 + Kd + Kf).*eps1;
Fmp_a = a2.*Kf./(Kn2_a + Kd + Kf).*eps2 + a1.*Kf./(Kn1 + Kd + Kf).*eps1;
Fop_a = a2.*Kf./(Kp2 + Kn2_a + Kd + Kf).*eps2 + a1.*Kf./(Kp1 + Kd + Kf).*eps1;
Fs_a = a2.*phi2F_a.*eps2 + a1.*phi1F_a.*eps1;

% PAM indices used in plotter_forward_fun.m
PAM1_a = 1 - Fs_a./Fmp_a; % PhiP
PAM2_a = Fs_a.*(1./Fmp_a - 1./Fm_a); % PhiN
PAM3_a = Fs_a./Fm_a; % PhiD + PhiF

% Other PAM indices used in paper
% PAM4_a = Q.*0.85./2.*PAM1_a; % ETR
% PAM5_a = (Fmp_a - Fs_a)./(Fmp_a - Fop_a); % qP
% PAM6_a = (Fmp_a - Fs_a).*Fop_a./((Fmp_a - Fop_a).*Fs_a); % qL
% PAM7_a = PAM4_a./(1-PAM5_a); % kPuddle
% PAM8_a = PAM4_a./(1-PAM6_a); % kLake
% PAM9_a = Fm_a./Fmp_a - 1; % NPQ

% Remove model input variables from workspace
clearvars   v ...
            Abs beta CB6F RUB Rds ...
            Kf Kd Kp1 Kn1 Kp2 Ku2 ...
            kq nl nc kc ko Kc Ko ...
            theta1 eps1 eps2 tr;
        
% Create structure to hold all remaining model output
m = workspace2struct_fun();

end