classdef Agent < handle
    
    % Agent for doing flood experiments
    % works with new MemoryModule abstract class 
    % and MemoryTimeline class
    %
    % note that Agent constructor must be called with a 
    % - MemoryModule constructor
    % - number of units and number of timesteps passed in 
    
    properties (Constant)
        baselineAlpha = 0.05;  % alpha storage for each pattern in time
        baselineNoiseCost = 0.1; % random noise to fill costs so it's not just 0
    end
    
    properties        
        M; % Memory module
        T; % ExperientialTimeline (includes past and future)
        wHA; % weight matrix from H to A
                
        nU, nT; % units and timesteps
        
        timelineEvents = {};
        % ImposeFlood TS alpha cost
        % RemindFlood TS floodTS reminderAlpha costDelta
    end
    
    methods
        function self = Agent(memorymodule_constructor, nU, nT, varargin)
            
            self.M = memorymodule_constructor(nU);
            self.M.FLAG_keepTrackOfPatterns = false;  % for speed - they are all in the MemoryTimeline anyway
            self.T = MemoryTimeline(self.M, 'nT', nT, varargin{:});
            
            self.nU = self.T.nU;
            self.nT = self.T.nT;
            
            self.baselineStore();
        end
        
        function AddEventToList(self, E)
            self.timelineEvents{end+1} = E;
        end
        
        function PrintEventList(self)
            for iE = 1:length(self.timelineEvents)
                disp(self.timelineEvents{iE});
            end
        end
        
        function baselineStore(self)
            fn = sprintf('%s-BaselineStore.mat', self.M.myName);
            if ~exist(fn, 'file')
                error('Must initialize matrix with stable state');
            else
                self.M.InitializeMatrix(fn);                
                self.wHA = self.baselineNoiseCost * randn(1,self.nU) / self.nU;
            end
        end
        
        % --- 
        % run timeline
        function [A,R,M] = runTimeline(self, varargin)
            % A is asset cost at time t
            % R is memory of asset cost given recall of M
            % M is correlation with old memory
            floodTS = 0; % if nonzero, then is number of trial to compare to
            process_varargin(varargin);
            
            A = nan(self.nT,1);
            R = nan(self.nT,1);
            M = nan(self.nT,1);
            
            eventTS = cellfun(@(x) x{2}, self.timelineEvents, 'UniformOutput', true);  % get times to act
            for iT = 1:self.nT          
                %if mod(iT,100)==1, fprintf('!'); elseif mod(iT,10)==1, fprintf('.'); end                

                f = find(iT==eventTS);
                if ~isempty(f)
                    for iF = 1:length(f)
                        feval(self.timelineEvents{f(iF)}{1}, self.timelineEvents{f(iF)}{2:end});
                    end
                end                               
                
                P = self.T.GetPattern(iT);
                self.M.AddOnePattern(P, self.baselineAlpha);
                
                P0 = self.M.Recall(P);
                A(iT) = self.wHA * P0;                
                if floodTS
                    [M(iT), R(iT)] = self.TestRecall(P0, floodTS); %#ok<*UNRCH>
                end                
            end            
        end
        
        % -- events
        
        function ImposeFlood(self, TS, alpha, cost)
            % TS = timestamp ("time of the flood")
            % alpha = salience
            % cost = experienced cost
            P = self.T.GetPattern(TS);                  
            self.M.AddOnePattern(P, alpha);
            self.wHA = self.wHA + P'.*cost/self.M.nU;
        end
                
        function RemindFlood(self, TS, floodTS, alpha, delta)  % alpha is change in salience, delta is change in cost
            P_recalled = self.RecallFlood(TS, floodTS);
            self.M.AddOnePattern(P_recalled, alpha);            
            rememberedCost = self.wHA * P_recalled;
            self.wHA = self.wHA + delta * P_recalled'.*rememberedCost/self.M.nU;
        end
                  
        function P_recalled = RecallFlood(self, TS, floodTS)
            P_then = self.T.GetPattern(floodTS);
            P_mix = P_then;             
            P_mix(self.T.martingaleUnits) = zeros(1, self.T.nM);
            P_recalled = self.M.Recall(P_mix);
        end
        
        function P_recalled = RecallMix(self, TS, floodTS)
            P_now = self.T.GetPattern(TS);
            P_then = self.T.GetPattern(floodTS);
            P_mix = [P_now(self.T.martingaleUnits); P_then(self.T.featureUnits)];
            P_recalled = self.M.Recall(P_mix);
        end
        
        function [rememory, recalledCost] = TestRecall(self, P_recalled, floodTS)
            % recall flood
            rememory = self.M.PatternSimilarity(P_recalled, self.T.GetPattern(floodTS));
            recalledCost = self.wHA * P_recalled;
        end        
    end
end    