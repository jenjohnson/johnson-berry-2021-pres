function [s] = plotter_forward_fun(outputname,v,m)

%% Load input variables

% Dock figures
set(0,'DefaultFigureWindowStyle','docked');

%% Make figure
figure1 = figure;

A_max = max(max(m.An_a));
A_min = min(min(m.An_a));

subplot(5,1,1)

if length(m.a2) == 1
    m.a2 = repmat(m.a2,length(m.Q),1);
    m.a1 = repmat(m.a1,length(m.Q),1);
end

plot(m.Q.*1e6,m.a2./v.Abs.*100,...
     m.Q.*1e6,m.a1./v.Abs.*100);
ylim([0 100]);
xlabel('PAR (umol PPFD m-2 s-1)');
ylabel('Cross-sections (%)');
h = legend('Photosystem II','Photosystem I');
set(h,'FontSize',8,'location', 'northeast');

subplot(5,1,2)
plot(m.Q.*1e6,m.PAM1_a);
ylim([0 1]);
xlabel('PAR (umol PPFD m-2 s-1)');
ylabel('Photochemical yield');

subplot(5,1,3)
plot(m.Q.*1e6,m.PAM2_a);
ylim([0 1]);
xlabel('PAR (umol PPFD m-2 s-1)');
ylabel('Reg. NPQ yield');

subplot(5,1,4)
plot(m.Q.*1e6,m.PAM3_a);
ylim([0 1]);
xlabel('PAR (umol PPFD m-2 s-1)');
ylabel('Residual yield');

subplot(5,1,5)
plot(m.Q.*1e6,m.An_a.*1e6);
ylim([-5 35]);
xlabel('PAR (umol PPFD m-2 s-1)');
ylabel('An (umol CO2 m-2 s-1)');

% Add title to plots
% sgtitle(outputname);

% Remove model input variables from workspace
clearvars   m v data;

% Create structure to hold all remaining model output
s = workspace2struct_fun();

end