classdef MemoryTimeline < handle
    
    properties
        nT0 = 100; % number of elements in the martingale        
        nF = 200; % number of elements in the feature space
        nTimeSteps = 1000; % number of timestep
        
        T; % timeline pattern                
        martingaleBits = 1;
    end
    
    methods
        % constructor
        function self = MemoryTimeline()
            self.T = nan(self.nTimeSteps, self.nT0 + self.nF);
            self.MakePatterns();
        end
        
        function n = nUnits(self), n = size(self.T,2); end
        function n = nSteps(self), n = size(self.T,1); end
        
        function MakePatterns(self)
            self.T = 2*(rand(self.nTimeSteps,self.nT0 + self.nF) > 0.5)-1;
            self.ResetMartingale(1);
        end
        
        function ResetMartingale(self, TS)
           % resets the Martingale at time TS
           self.T(TS,1:self.nT0) = 2*(rand(1,self.nT0) > 0.5)-1;
           for iTS = TS+1:self.nTimeSteps               
               bitsToFlip = randi(self.nT0,[self.martingaleBits,1]);
               self.T(iTS, 1:self.nT0) = self.T(iTS-1, 1:self.nT0);
               self.T(iTS, bitsToFlip) = -self.T(iTS, bitsToFlip);
           end
        end
        
        function P = getPattern(self,iX)
            P = self.T(iX,:);
        end
    end
end