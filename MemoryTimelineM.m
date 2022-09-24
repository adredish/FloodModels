classdef MemoryTimelineM < handle
    
    properties
        nT0 = 500; % number of elements in the martingale        
        martingaleUnits;
        
        nF = 500; % number of elements in the feature space
        featureUnits;
        
        nTimeSteps = 750; % number of timestep
        
        T; % timeline pattern nU x nP             
        martingaleProportion = 0.1;  % percent change from step to step
        
    end
       
    methods
        % constructor
        function self = MemoryTimelineM(varargin)
            self.processParms(varargin);
            self.T = nan(self.nTimeSteps, self.nT0 + self.nF);
            self.martingaleUnits = 1:self.nT0;
            self.featureUnits = (self.nT0+(1:self.nF));
            self.MakePatterns();
        end
        
        function processParms(self,V)
            for iV = 1:2:length(V)
                switch(V{iV})
                    case 'nT0', self.nT0 = V{iV+1};
                    case 'nF', self.nF = V{iV+1};
                    case 'nTimeSteps', self.nTimeSteps = V{iV+1};
                    case 'martingaleBits', self.martingaleBits = V{iV+1};
                end
            end
        end			
        
        function n = nUnits(self), n = size(self.T,1); end
        function n = nSteps(self), n = size(self.T,2); end
        
        function MakePatterns(self)
            self.T = MemoryModule.MakePatterns(self.nUnits, self.nSteps);
            self.ResetMartingale(1);
        end
        
        function ResetMartingale(self, TS)           
           % resets the Martingale at time TS
           noise = self.martingaleProportion * randn(self.nT0, self.nSteps);
           for iTS = TS:(self.nTimeSteps-1)
               T0 = self.T(self.martingaleUnits, iTS);
               N0 = noise(self.martingaleUnits, iTS+1);
               self.T(self.martingaleUnits, iTS+1) = T0 + N0;
           end
        end
        
        function P = getPattern(self,iX)
            P = self.T(:,iX);
        end
    end
end