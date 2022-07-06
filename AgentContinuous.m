classdef AgentContinuous < Agent
    
    methods
        function name = Name(self)
            name = 'Agent with continuous hopfield network';
        end
        
        function self = AgentContinuous(varargin)
            self.T = MemoryTimeline(varargin{:});
            self.H = HopfieldContinuous(self.T.nUnits);
            self.baselineStore();
        end
    end
end
