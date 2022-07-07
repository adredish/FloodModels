classdef Agent < handle
    
    properties        
        H; % hopfield net for memory 
        T; % ExperientialTimeline (includes past and future)
        wHA; % weight matrix from H to A
        
        baselineNoiseAlpha = 0.1; % baseline noise for weight matrix
        baselineNoiseCost = 0.1; % baseline to put noise into the cost
        baselineAlpha = 0.06; % baseline storage for all experiences
        baselineRandStore = 0; % store this many random patterns to put noise in the system        
        
        timelineEvents = {};
        % ImposeFlood TS alpha cost
        % RemindFlood TS floodTS
        % Alleviatememory TS floodTS alpha
    end
    
    methods
        function name = Name(self)
            name = 'Agent with standard hopfield network';
        end

        function self = Agent(varargin)
            self.T = MemoryTimeline(varargin{:});
            self.H = Hopfield(self.T.nUnits);
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
           self.H.W = self.baselineNoiseAlpha * randn(self.T.nUnits);
           self.wHA = self.baselineNoiseCost * randn(1,self.H.nU) / self.T.nUnits;            
           for iT = 1:self.baselineRandStore
                P = self.H.RandPattern();
                self.H.AddOnePattern(P, 1.0);
            end
            
        end
        
        % --- 
        % run timeline
        function [A,R,M] = runTimeline(self, varargin)
            % A is asset cost at time t
            % R is memory of asset cost given recall of M
            % M is correlation with old memory
            flagTestRecall = false; % if nonzero, then is number of trial to compare to
            process_varargin(varargin);
            
            A = nan(self.T.nSteps,1);
            if flagTestRecall
                R = nan(self.T.nSteps,1);
                M = nan(self.T.nSteps,1);
            end
            
            eventTS = cellfun(@(x) x{2}, self.timelineEvents, 'UniformOutput', true);  % get times to act
            for iT = 1:self.T.nSteps                
                %h = waitbar(iT/self.T.nSteps);
                f = find(iT==eventTS);
                if ~isempty(f)
                    for iF = 1:length(f)
                        feval(self.timelineEvents{f(iF)}{1}, self.timelineEvents{f(iF)}{2:end});
                    end
                end                               
                
                P = self.T.getPattern(iT);
                self.H.AddOnePattern(P, self.baselineAlpha);
                
                P0 = self.H.Recall(P);
                A(iT) = P0*self.wHA';
                
                if flagTestRecall
                    [M(iT), R(iT)] = self.TestRecall(iT, flagTestRecall);
                end                
            end
            %delete(h);
            
            for iA = 2:length(A)
                if isnan(A(iA)), A(iA) = A(iA-1); end
            end
            
        end
        
        % -- events
        
        function ImposeFlood(self, TS, alpha, cost)
            % TS = timestamp ("time of the flood")
            % alpha = salience
            % cost = experienced cost
            P = self.T.getPattern(TS);                  
            self.H.AddOnePattern(P, alpha);
            self.wHA = self.wHA + P.*cost/self.H.nU;
        end
          
        function P_recalled = RecallFlood(self, floodTS)
            P_then = self.T.getPattern(floodTS);
            P_mix = [zeros(1, self.T.nT0), P_then((self.T.nT0+1):end)];
            P_recalled = self.H.Recall(P_mix);
        end
        
        function P_recalled = RecallMix(self, TS, floodTS)
            P_now = self.T.getPattern(TS);
            P_then = self.T.getPattern(floodTS);
            P_mix = [P_now(1:self.T.nT0), P_then((self.T.nT0+1):end)];
            P_recalled = self.H.Recall(P_mix);
        end
        
        function RemindFlood(self, ~, floodTS, alpha)
            P_recalled = self.RecallFlood(floodTS);
            self.H.AddOnePattern(P_recalled, alpha);
        end
               
        function AlleviateFlood(self, ~, floodTS, alpha)
            P_recalled = self.RecallFlood(floodTS);
            rememberedCost = P_recalled * self.wHA';            
            % alleviate
            self.wHA = self.wHA - alpha * P_recalled.*rememberedCost/self.H.nU;
        end
            
        function [rememory,recalledCost] = TestRecall(self, TS, floodTS)
            % recall flood
            P_then = self.T.getPattern(floodTS);
            P_recalled = self.RecallMix(TS, floodTS);
            C = corrcoef(P_recalled, P_then);
            rememory = C(2);
            if rememory > 0
                recalledCost = P_recalled*self.wHA';
            else % Hopfield can invert
                rememory = -rememory;
                recalledCost = -P_recalled * self.wHA';
            end
        end

        
    end
end    