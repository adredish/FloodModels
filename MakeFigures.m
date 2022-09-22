set(0,'DefaultFigureWindowStyle','docked')
%set(0,'DefaultFigureWindowStyle','normal')

%% figure 3 Flashbulb memories
clear; clc; close all hidden
load DATA_Reminders.mat

separateFigures = false;
ShowParm('AssetCost', 'Reminders', nTS, R, L, floodTS, reminders, 'flagSeparateFigures', separateFigures);
ShowParm('Rememory', 'Reminders', nTS, R, L, floodTS, reminders, 'flagSeparateFigures', separateFigures);
ShowParm('RememberedCost', 'Reminders', nTS, R, L, floodTS, reminders, 'flagSeparateFigures', separateFigures);
WriteFigures('Reminders-00');

%% 
clear; clc; close all hidden
load DATA_Reassessments.mat

separateFigures = false;
ShowParm('AssetCost', 'Reassessments', nTS, R, L, floodTS, alleviations, 'flagSeparateFigures', separateFigures);
ShowParm('AssetCost', 'Reassessments', nTS, R, L, floodTS, alleviations, 'flagSeparateFigures', separateFigures); legend off
ShowParm('Rememory', 'Reassessments', nTS, R, L, floodTS, alleviations, 'flagSeparateFigures', separateFigures);legend off
ShowParm('RememberedCost', 'Reassessments', nTS, R, L, floodTS, alleviations, 'flagSeparateFigures', separateFigures);legend off

WriteFigures('Reassessments');
%% 
clear; clc; close all hidden
load DATA_Alleviations.mat

separateFigures = false;
ShowParm('AssetCost', 'Alleviations', nTS, R, L, floodTS, alleviations, 'flagSeparateFigures', separateFigures);;
ShowParm('AssetCost', 'Alleviations', nTS, R, L, floodTS, alleviations, 'flagSeparateFigures', separateFigures);; legend off
ShowParm('Rememory', 'Alleviations', nTS, R, L, floodTS, alleviations, 'flagSeparateFigures', separateFigures);; legend off
ShowParm('RememberedCost', 'Alleviations', nTS, R, L, floodTS, alleviations, 'flagSeparateFigures', separateFigures);; legend off

WriteFigures('Alleviations');

%%
clear; clc; close all hidden
load DATA_PTSD.mat

ShowParm('AssetCost', 'PTSD', nTS, R, L, floodTS, []);
ShowParm('Rememory',  'PTSD', nTS, R, L, floodTS, []);
ShowParm('RememberedCost',  'PTSD', nTS, R, L, floodTS, []);

WriteFigures('PTSD');

%%
clear; clc; close all hidden
set(0,'DefaultFigureWindowStyle','normal')

load DATA_salience.mat
ShowSalienceCostSet('AssetCost', 'Basic Flood', nTS, R, salience, cost, floodTS);
ShowSalienceCostSet('Rememory', 'Basic Flood',nTS, R, salience, cost, floodTS);
ShowSalienceCostSet('RememberedCost', 'Basic Flood', nTS, R, salience, cost, floodTS);

%WriteFigures('Salience x Cost');
%%
function WriteFigures(T)
fd = '../Figures';
figureset = findobj('Type', 'figure');
for iFig = 1:length(figureset)
    print(figure(iFig), fullfile(fd,sprintf('%s-%d.png', T, iFig)), '-dpng');
    print(figure(iFig), fullfile(fd,sprintf('%s-%d.svg', T, iFig)), '-dsvg');
end
end
