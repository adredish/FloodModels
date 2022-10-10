function MakeFigure_04_SalienceAndCost(varargin)

%% Figure 4/5/6
M = @MemoryModule_Hopfield;
nA = 5;

nT = 1000;
floodTS = 50;
salience = [0 0.5 0.75 1];  % salience = [0 0.5 1.0 1.5 2.0];
cost = [0 0.5 1]; % cost = [0 0.25 0.5 0.75 1];

recalculate = false;
separate_figures = false;
process_varargin(varargin);

%%
R = [];
if ~recalculate && exist('Data_04_SalienceCost.mat', 'file')
    savedData = load('Data_04_SalienceCost.mat');
    if isequal(savedData.M,M) && savedData.nA == nA
        R = savedData.R;
    end
end
if isempty(R)
    R = Run1Exp('nA', nA, 'nT', nT, 'floodTS', floodTS, ...
        'Memory2Use', M, ...
        'salience', salience, 'cost', cost);
    R.salience = salience;
    R.cost = cost;
    R.floodTS = floodTS;
    save Data_04_SalienceCost R M nA 
end

disp('done');

%%
ShowSalienceCostSet(R, 'AssetCost');  
ShowSalienceCostSet(R, 'Rememory');
ShowSalienceCostSet(R, 'RememberedCost');

%% ============================================================
function ShowSalienceCostSet(R, parm)
salience = R.salience; nS = length(salience);
cost = R.cost;  nC = length(cost);
nT = size(R.AssetCost,4);
c = MakeColorMap2D(nS, nC);

figure; iP = 1;
for iC = 1:nC
    for iS = 1:nS
        subplot(nC+1, nS+1, iP); iP = iP+1;
        X = squeeze(R.(parm)(iS,iC,:,:));
        h= ShadedErrorbar(1:nT, nanmean(X), nanstderr(X), 'color', squeeze(c(iS, iC, :)));
        %h = plot(1:nT, nanmean(X), 'color', squeeze(c(iS, iC, :)));
        CleanPlot()
        legend(h,sprintf('s=%.1f\nc=%.2f', salience(iS), cost(iC)));
    end
    
    % all saliences
    subplot(nC+1, nS+1, iP); iP = iP+1;
    for jS = 1:nS
        hold on
        ShadedErrorbar(1:nT, nanmean(squeeze(R.(parm)(jS,iC,:,:))), nanstderr(squeeze(R.(parm)(jS,iC,:,:))), 'color', squeeze(c(jS, iC, :)));
        %plot(1:nT, nanmean(squeeze(R.(parm)(jS,iC,:,:))), 'color', squeeze(c(jS, iC, :)));
    end
    CleanPlot()
end
% all costs
for iS = 1:nS
    subplot(nC+1, nS+1, iP); iP = iP+1;
    for jC = 1:nC
        hold on
        ShadedErrorbar(1:nT, nanmean(squeeze(R.(parm)(iS,jC,:,:))), nanstderr(squeeze(R.(parm)(iS,jC,:,:))), 'color', squeeze(c(iS, jC, :)));
        %plot(1:nT, nanmean(squeeze(R.(parm)(iS,jC,:,:))), 'color', squeeze(c(iS, jC, :)));
    end
    CleanPlot()
end

if ~separate_figures
    h = axes(gcf, 'visible', 'off');
    ylabel(h, 'Cost', Visible=true);
    xlabel(h, 'Time, Flood @ timestep 50', Visible=true);
    FigureLayout('layout', [1 1], 'scaling', 2);
    set(findobj('Type', 'legend'), 'FontSize', 12, 'location', 'northeast');
end

% Make Color Map 2D
    function I = MakeColorMap2D(nX, nY)
        red = repmat(linspace(1,0,nY), nX,1);
        grn = repmat(linspace(1,0,nX)',1,nY);
        blu = repmat(linspace(0,1,nY), nX,1);
        I = cat(3,red,grn,blu);
    end

% Clean Plot - cleans up the plot to have the right axes
    function CleanPlot()
        set(gca, 'XTick', [0 1000], 'YTick', [0 1]);
        ylim([0 1]);
        line([R.floodTS R.floodTS], ylim, 'color', 'k');
        if separate_figures
            FigureLayout('scaling', 6);
        end
    end

    sgtitle(parm);
end
end