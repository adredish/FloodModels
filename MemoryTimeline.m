classdef MemoryTimeline < handle
    
    % Memory Timeline
    %
    % contains the patterns for an experiment
    % creates a martingale process for nM units and random feature for nF units
    % note that the constructor requires a PatternConstructor be passed in
    % this is typically @MemoryModule_Type.MakePatterns
    %
    % patterns are stored nU x nP (to match the memory modules
    
    properties
        pM = 0.5, nM; % number of elements in the martingale
        pF, nF; % number of elements in the feature space
        nU; % total units
        martingaleUnits, featureUnits;  % booleans for those units
        martingaleNoise = 0.1;  % percent change from step to step
        
        nT = 750; % number of timesteps
        
        T; % timeline pattern nU x nP
        M; % memory module associated with this timeline
        
    end
    
    methods
        % constructor
        function self = MemoryTimeline(M, varargin)
            % must be called with memory module
            self.ProcessParms(varargin);
            self.nU = M.nU;
            self.nM = ceil(self.nU * self.pM);  
            self.nF = self.nU - self.nM;
            self.pF = self.nF/self.nU;
            
            self.martingaleUnits = 1:self.nM;
            self.featureUnits = (self.nM +(1:self.nF));
            
            % make patterns
            self.M = M;
            self.T = M.MakePatterns(self.nT, self.nU);
            self.ResetMartingale(1);
            
        end
        
        function ProcessParms(self,V)
            for iV = 1:2:length(V)
                switch(V{iV})
                    case 'pM', self.pM = V{iV+1};
                    case 'martingaleNoise', self.martingaleNoise = V{iV+1};
                    case 'nT', self.nTimeSteps = V{iV+1};
                end
            end
        end
        
        function ResetMartingale(self, TS)
            % resets the Martingale at time TS
            for iTS = TS:(self.nT-1)
                T0 = self.T(self.martingaleUnits, iTS);                
                N0 = self.M.AddNoise(T0, self.martingaleNoise);
                self.T(self.martingaleUnits, iTS+1) = N0;
            end
        end
        
        function P = GetPattern(self,iX)
            P = self.T(:,iX);
        end
    end
end