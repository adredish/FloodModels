function MakeFigure_03_BasicExperiment(varargin)

% MakeFigure_03_BasicExperiment(M, nA, varargin)

M = @MemoryModule_Hopfield;
nA = 5;
recalculate = false;
separate_figures = false;

process_varargin(varargin);

%%
R = [];
if ~recalculate && exist('Data_03_BasicExperiment.mat', 'file')
    savedData = load('Data_03_BasicExperiment.mat');
    if isequal(savedData.M,M) && savedData.nA == nA
        R = savedData.R;
    end
end
if isempty(R)
    disp('Recalculating');
    R.baseline = Run1Exp('Memory2use', M, 'nA', nA, 'color','k');
    R.reminder = Run1Exp('Memory2use', M, 'nA', nA, 'events', {[250 1 0]});
    R.reassessment = Run1Exp('Memory2use', M, 'nA', nA, 'events', {[250 0.1 0.5]});
    R.alleviation = Run1Exp('Memory2use', M, 'nA', nA, 'events', {[250 0.1 -0.5]});
    save Data_03_BasicExperiment.mat R M nA
end

%% showdata
Show3(R.baseline, 'k', 'separate_figures', separate_figures); 

Show3(R.reminder, 'm', 'separate_figures', separate_figures); 

Show3(R.reassessment, 'm', 'separate_figures', separate_figures); 

Show3(R.alleviation, 'm', 'separate_figures', separate_figures);

%% ======================================

end