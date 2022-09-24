function R = EXP_FlashbulbMemories(varargin)
nA = 25;
nTS = 500;
salience = 1; % [0 1 2 5 10];
cost = 0.75; % [0 1 5 10 20];
floodTS = 100;
reminderTS = 250;
reminderAlpha = 0.2;
AgentType = @Agent; % @AgentContinuous
process_varargin(varargin);
rng('shuffle');

nS = length(salience);  R.salience = salience;
nC = length(cost); R.cost = cost;

AssetCost = nan(nS, nC, nA, nTS);
RememberedCost = nan(nS, nC, nA, nTS);
Rememory = nan(nS, nC, nA, nTS);

T = nan(nS*nC); iT = 1;
for iS = 1:nS
    for iC = 1:nC        
        tic;
        fprintf('s=%.1f; c = %.1f: ', salience(iS), cost(iC));
        for iA = 1:nA
            if nA < 100 
                fprintf('.');
            elseif mod(iA,10)==1
                fprintf('o');
            end
            
            A = AgentType('nTimeSteps', nTS);
            R.AgentType = A.Name;
            A.AddEventToList({@A.ImposeFlood, floodTS, salience(iS), cost(iC)});
            if any(reminderTS)
                for iR = 1:length(reminderTS)
                    A.AddEventToList({@A.RemindFlood, reminderTS(iR), floodTS, reminderAlpha});
                end
            end
            [AssetCost(iS,iC,iA,:), RememberedCost(iS,iC,iA,:), Rememory(iS,iC,iA,:)] = A.runTimeline('flagTestRecall', floodTS);
            delete(A);
        end
        T(iT) = toc;
        fprintf(': %.2f s (%.0f s remaining)\n', T(iT), nanmean(T(iT)) * (nS*nC - iT));
        iT = iT+1;
    end
end


R.AssetCost = AssetCost;
R.Rememory = Rememory;
R.RememberedCost = RememberedCost;
R.separatePlots = false;

end
