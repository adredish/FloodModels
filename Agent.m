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