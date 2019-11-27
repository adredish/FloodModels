classdef Agent < handle
    
    properties
        H; % hopfield net for memory 
        T; % ExperientialTimeline (includes past and future)
        wHA; % weight matrix from H to A
        baselineAlpha = 0.0001; % baseline storage for all experiences
    end
    
    methods
        function self = Agent()
            self.T = MemoryTimeline;
            self.H = Hopfield(self.T.T, self.baselineAlpha);
            self.wHA = zeros(1,self.H.nU);
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
        
        function A = getAssetCost(self)
            A = self.T.T * self.wHA'; 
        end
    end
end    