%% EXPERIMENTS
%% Flashbulb memory, effects of reminders
disp('-------------------------- Memories and reminders ------------------');
clear
Test_FlashbulbMemories;
save DATA_Reminders.mat

%% Alleviations
disp('-------------------------- Alleviations ------------------');
clear
Test_Alleviations;
save DATA_Alleviations 

%% PTSD
disp('-------------------------- PTSD ------------------');
clear
Test_PTSD;
save DATA_PTSD 

%%
disp('-------------------------- Salience and cost ------------------');
clear
Test_Basic
save DATA_salience.mat 
