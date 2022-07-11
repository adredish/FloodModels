%% figure 3 Flashbulb memories
clear; clc; close all hidden
load DATA_Reminders.mat

ShowParm('AssetCost', nTS, R, L, floodTS, reminders);
ShowParm('Rememory', nTS, R, L, floodTS, reminders);
ShowParm('RememberedCost', nTS, R, L, floodTS, reminders);

%% 
clear; clc; close all hidden
load DATA_Reassessments.mat

ShowParm('AssetCost', nTS, R, L, floodTS, alleviations);
ShowParm('RememberedCost', nTS, R, L, floodTS, alleviations);

%% 
clear; clc; close all hidden
load DATA_Alleviations.mat

ShowParm('AssetCost', nTS, R, L, floodTS, alleviations);
ShowParm('RememberedCost', nTS, R, L, floodTS, alleviations);

%%
clear; clc; close all hidden
load DATA_PTSD.mat

ShowParm('AssetCost', nTS, R, L, floodTS, []);
ShowParm('Rememory', nTS, R, L, floodTS, []);
ShowParm('RememberedCost', nTS, R, L, floodTS, []);

%%
clear; clc; close all hidden
load DATA_salience.mat
ShowSalienceCostSet('AssetCost', nTS, R, salience, cost, floodTS);
ShowSalienceCostSet('Rememory', nTS, R, salience, cost, floodTS);
ShowSalienceCostSet('RememberedCost', nTS, R, salience, cost, floodTS);
