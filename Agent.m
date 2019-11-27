classdef Agent < handle
    
    properties
        H; % hopfield net for memory 
        T; % ExperientialTimeline (includes past and future)
        wHA; % weight matrix from H to A
        baselineAlpha = 0.0001; % baseline storage for all experiences
        cycleStorage = 50;
        cycleAlpha = 1.0;
    end
    
    methods
        function self = Agent(varargin)
            self.T = feval(@MemoryTimeline,varargin{:});
            self.H = Hopfield(self.T.T, self.baselineAlpha);
            self.wHA = zeros(1,self.H.nU);     
        end
        
        function CycleStore(self, t0, t1)
            if nargin==1
                t0 = 1; t1 = self.T.nSteps;
            end
            for iT = t0:self.cycleStorage:t1
                P = self.T.getPattern(iT);
                self.H.AddOnePattern(P, self.cycleAlpha);
            end
        end
        
        function ImposeFlood(self, TS, alpha, cost)
            % TS = timestamp ("time of the flood")
            % alpha = salience
            self.T.ResetMartingale(TS);
            self.H.AddOnePattern(self.T.T(TS:end,:), self.baselineAlpha);
            P = self.T.getPattern(TS);            
            self.H.AddOnePattern(P, alpha);
            % cost = experienced cost
            self.wHA = self.wHA + P.*cost/self.H.nU;
        end
        
        function RemindFlood(self, TS, floodTS)
            % recall flood
            P_now = self.T.getPattern(TS);
            P_then = self.T.getPattern(floodTS);
            P_recall_start = cat(2,P_now(1:self.T.nT0),P_then(self.T.nT0 + (1:self.T.nF)));
            P_recalled = self.H.Recall(P_recall_start);
            % recall cost
            rememberedCost = P_recalled * self.wHA';            
            % impose on present
            self.wHA = self.wHA + P_now.*rememberedCost/self.H.nU;
        end
        
        function AlleviateMemory(self, floodTS, alpha)
            % recall flood
            P_then = self.T.getPattern(floodTS);
            P_recalled = self.H.Recall(P_then);
            % recall cost
            rememberedCost = P_recalled * self.wHA';            
            % alleviate
            self.wHA = self.wHA - alpha * P_recalled.*rememberedCost/self.H.nU;
        end
            
        function A = getAssetCostNoRecall(self)
            A = self.T.T * self.wHA';
        end

        function A = getAssetCost(self, cycleSteps)
            if nargin==1, cycleSteps = 1; end
            A = nan(self.T.nSteps,1);
            for iT = 1:cycleSteps:self.T.nSteps
                P = self.T.getPattern(iT);
                P0 = self.H.Recall(P);
                A(iT) = P0*self.wHA';
            end
            for iA = 2:length(A)
                if isnan(A(iA)), A(iA) = A(iA-1); end
            end
        end
        
    end
end    