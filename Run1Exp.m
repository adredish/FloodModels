function R = Run1Exp(varargin)

% run one experiment

nA = 25;
nU = 500;
nT = 1000;
salience = 0.5; % [0 1 2 5 10];
cost = 1; % [0 1 5 10 20];
floodTS = 50;

events = {};  % cell array of <T, alpha, delta> triples

Memory2use = @MemoryModule_Hopfield; %@MemoryModule_OuterProduct;  % @MemoryModule_Hopfield
process_varargin(varargin);

%---------------------------------------------
% randomize seed
rng('shuffle');
assert(isempty(events) || all(cellfun(@length, events)==3));

%---------------------------------------------
% prep R
nS = length(salience);  R.salience = salience;
nC = length(cost); R.cost = cost;

R.events.flood = floodTS;
R.events.events = events;

AssetCost = nan(nS, nC, nA, nT);
RememberedCost = nan(nS, nC, nA, nT);
Rememory = nan(nS, nC, nA, nT);

%--------------------------------------------
% GO
T = nan(nS*nC); iT = 1;
for iS = 1:nS
    for iC = 1:nC        
        tic;
        fprintf('s=%.1f; c = %.2f: ', salience(iS), cost(iC));
        
        for iA = 1:nA
            if (nA < 100), fprintf('.'); elseif (mod(iA,10)==1), fprintf('!'); end
                       
            % run one agent
            A = Agent(Memory2use, nU, nT);
            R.MemoryType = A.M.myName;
            A.M.FLAG_keepTrackOfPatterns = false;
            
            if any(floodTS)
                for iR = 1:length(floodTS)
                    A.AddEventToList({@A.ImposeFlood, floodTS(iR), salience(iS), cost(iC)});
                end
            end
            if ~isempty(events)
                for iR = 1:length(events)
                    A.AddEventToList({@A.RemindFlood, events{iR}(1), floodTS, events{iR}(2), events{iR}(3)});
                end
            end
            
            [AssetCost(iS,iC,iA,:), RememberedCost(iS,iC,iA,:), Rememory(iS,iC,iA,:)] = A.runTimeline('floodTS', floodTS(1));
            
            delete(A);
        end
        
        % close up from this test
        T(iT) = toc;
        fprintf(': %.2f s (%.0f s remaining)\n', T(iT), nanmean(T(iT)) * (nS*nC - iT));
        iT = iT+1;
    end
end

R.AssetCost = AssetCost;
R.Rememory = Rememory;
R.RememberedCost = RememberedCost;


end
