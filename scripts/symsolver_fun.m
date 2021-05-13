%% Symbolic solution for optimal absorption cross-sections
%
% Note 1: The commented text requires MATLAB's Symbolic Math Toolbox
% (https://www.mathworks.com/products/symbolic.html) or Octave's Symbolic 
% Package (https://octave.sourceforge.io/symbolic/index.html). 
%
% Note 2: For simplicity, an equivalent anonymous function is provided at
% the end of this file. This function can be used in MATLAB without the 
% Symbolic Math Toolbox or in Octave without the Symbolic Package.

% %% Definition of symbols
% 
% % Clean up working environment
% clearvars -except currdir workdir resultsdir;
% 
% Define symbols
% syms Abs CB6F JP700_j Kd Kf Kp2 Ku2 Q ...
%      a2 eta kq phi1P_max phi2P_a phi2p_a phi2u_a q2_a;
% 
% %% Find optimal abs. cross-section of PS2:
% 
% eq1 = JP700_j - Q.*a2.*phi2P_a.*eta == 0;
% eq2 = subs(eq1,JP700_j, Q.*CB6F.*kq./(Q+CB6F.*kq./((Abs-a2).*(phi1P_max))));
% eq3 = subs(eq2, phi2P_a, phi2p_a./(1-phi2u_a));
% eq4 = subs(eq3, phi2p_a, (q2_a).*Kp2./(Kp2 + Kd + Kf + Ku2));
% eq5 = subs(eq4, phi2u_a, (q2_a).*Ku2./(Kp2 + Kd + Kf + Ku2) + (1 - q2_a).*Ku2./(Kd + Kf + Ku2));
% eq6 = subs(eq5, q2_a, 1 - (Q./(Q+CB6F.*kq./((Abs-a2).*(phi1P_max)))));
% soln_xcs = solve(eq6,a2);
% clear eq1 eq2 eq3 eq4 eq5 eq6;
% 
% % Pass out second root:
% solve_xcs = matlabFunction(simplify(soln_xcs(1,1))); 
% % fn is @(Abs,CB6F,Kd,Kf,Kp2,Ku2,Q,eta,kq,phi1P_max)
% 
% %% Clean up workspace
% symObj = syms;
% cellfun(@clear,symObj);
% clear symObj;

%% Anonymous function defined as above and compatible with MATLAB & Octave:

solve_xcs = @(Abs,CB6F,Kd,Kf,Kp2,Ku2,Q,eta,kq,phi1P_max)(-sqrt((Kd+Kf+Ku2).*(CB6F.^2.*Kd.^3.*kq.^2.*phi1P_max.^2+CB6F.^2.*Kf.^3.*kq.^2.*phi1P_max.^2+CB6F.^2.*Kd.*Kp2.^2.*eta.^2.*kq.^2+CB6F.^2.*Kf.*Kp2.^2.*eta.^2.*kq.^2+CB6F.^2.*Kp2.^2.*Ku2.*eta.^2.*kq.^2+CB6F.^2.*Kd.*Kf.^2.*kq.^2.*phi1P_max.^2.*3.0+CB6F.^2.*Kd.^2.*Kf.*kq.^2.*phi1P_max.^2.*3.0+CB6F.^2.*Kd.*Kp2.^2.*kq.^2.*phi1P_max.^2+CB6F.^2.*Kd.^2.*Kp2.*kq.^2.*phi1P_max.^2.*2.0+CB6F.^2.*Kf.*Kp2.^2.*kq.^2.*phi1P_max.^2+CB6F.^2.*Kf.^2.*Kp2.*kq.^2.*phi1P_max.^2.*2.0+CB6F.^2.*Kd.^2.*Ku2.*kq.^2.*phi1P_max.^2+CB6F.^2.*Kf.^2.*Ku2.*kq.^2.*phi1P_max.^2+CB6F.^2.*Kp2.^2.*Ku2.*kq.^2.*phi1P_max.^2+Abs.^2.*Kd.*Kp2.^2.*Q.^2.*eta.^2.*phi1P_max.^2+Abs.^2.*Kf.*Kp2.^2.*Q.^2.*eta.^2.*phi1P_max.^2+Abs.^2.*Kp2.^2.*Ku2.*Q.^2.*eta.^2.*phi1P_max.^2+CB6F.^2.*Kd.*Kf.*Kp2.*kq.^2.*phi1P_max.^2.*4.0+CB6F.^2.*Kd.*Kf.*Ku2.*kq.^2.*phi1P_max.^2.*2.0+CB6F.^2.*Kd.*Kp2.*Ku2.*kq.^2.*phi1P_max.^2.*2.0+CB6F.^2.*Kf.*Kp2.*Ku2.*kq.^2.*phi1P_max.^2.*2.0+CB6F.^2.*Kd.*Kp2.^2.*eta.*kq.^2.*phi1P_max.*2.0+CB6F.^2.*Kd.^2.*Kp2.*eta.*kq.^2.*phi1P_max.*2.0+CB6F.^2.*Kf.*Kp2.^2.*eta.*kq.^2.*phi1P_max.*2.0+CB6F.^2.*Kf.^2.*Kp2.*eta.*kq.^2.*phi1P_max.*2.0+CB6F.^2.*Kp2.^2.*Ku2.*eta.*kq.^2.*phi1P_max.*2.0+CB6F.^2.*Kd.*Kf.*Kp2.*eta.*kq.^2.*phi1P_max.*4.0+CB6F.^2.*Kd.*Kp2.*Ku2.*eta.*kq.^2.*phi1P_max.*2.0+CB6F.^2.*Kf.*Kp2.*Ku2.*eta.*kq.^2.*phi1P_max.*2.0+Abs.*CB6F.*Kd.*Kp2.^2.*Q.*eta.*kq.*phi1P_max.^2.*2.0+Abs.*CB6F.*Kd.*Kp2.^2.*Q.*eta.^2.*kq.*phi1P_max.*2.0+Abs.*CB6F.*Kd.^2.*Kp2.*Q.*eta.*kq.*phi1P_max.^2.*2.0+Abs.*CB6F.*Kf.*Kp2.^2.*Q.*eta.*kq.*phi1P_max.^2.*2.0+Abs.*CB6F.*Kf.*Kp2.^2.*Q.*eta.^2.*kq.*phi1P_max.*2.0+Abs.*CB6F.*Kf.^2.*Kp2.*Q.*eta.*kq.*phi1P_max.^2.*2.0-Abs.*CB6F.*Kp2.^2.*Ku2.*Q.*eta.*kq.*phi1P_max.^2.*2.0+Abs.*CB6F.*Kp2.^2.*Ku2.*Q.*eta.^2.*kq.*phi1P_max.*2.0+Abs.*CB6F.*Kd.*Kf.*Kp2.*Q.*eta.*kq.*phi1P_max.^2.*4.0+Abs.*CB6F.*Kd.*Kp2.*Ku2.*Q.*eta.*kq.*phi1P_max.^2.*2.0+Abs.*CB6F.*Kf.*Kp2.*Ku2.*Q.*eta.*kq.*phi1P_max.^2.*2.0))+CB6F.*Kd.^2.*kq.*phi1P_max+CB6F.*Kf.^2.*kq.*phi1P_max+Abs.*Kd.^2.*Q.*phi1P_max.^2.*2.0+Abs.*Kf.^2.*Q.*phi1P_max.^2.*2.0+CB6F.*Kd.*Kp2.*eta.*kq+CB6F.*Kf.*Kp2.*eta.*kq+CB6F.*Kp2.*Ku2.*eta.*kq+CB6F.*Kd.*Kf.*kq.*phi1P_max.*2.0+CB6F.*Kd.*Kp2.*kq.*phi1P_max+CB6F.*Kf.*Kp2.*kq.*phi1P_max+CB6F.*Kd.*Ku2.*kq.*phi1P_max+CB6F.*Kf.*Ku2.*kq.*phi1P_max+CB6F.*Kp2.*Ku2.*kq.*phi1P_max+Abs.*Kd.*Kf.*Q.*phi1P_max.^2.*4.0+Abs.*Kd.*Kp2.*Q.*phi1P_max.^2.*2.0+Abs.*Kf.*Kp2.*Q.*phi1P_max.^2.*2.0+Abs.*Kd.*Ku2.*Q.*phi1P_max.^2.*2.0+Abs.*Kf.*Ku2.*Q.*phi1P_max.^2.*2.0+Abs.*Kd.*Kp2.*Q.*eta.*phi1P_max+Abs.*Kf.*Kp2.*Q.*eta.*phi1P_max+Abs.*Kp2.*Ku2.*Q.*eta.*phi1P_max)./(Q.*phi1P_max.*(Kd.^2.*phi1P_max+Kf.^2.*phi1P_max+Kd.*Kp2.*eta+Kf.*Kp2.*eta+Kp2.*Ku2.*eta+Kd.*Kf.*phi1P_max.*2.0+Kd.*Kp2.*phi1P_max+Kf.*Kp2.*phi1P_max+Kd.*Ku2.*phi1P_max+Kf.*Ku2.*phi1P_max).*2.0);

