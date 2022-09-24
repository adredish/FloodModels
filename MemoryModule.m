classdef (Abstract) MemoryModule < handle
    
    % Abstract memory module class
    % 
    % patterns are stored as nU x nP
    % weight matrix is nU x nU
    
    properties         
        FLAG_keepTrackOfPatterns = false;
        P % stored patterns [nU x nP]
        M % weight matrix [nU x nU]
        
        tau=0; % baseweight when adding patterns

    end
    
    methods        
        function z = myName(~), z = 'MemoryModuleAbstract'; end

        % constructor
        function self  = MemoryModule(nU)  
            self.M = zeros(nU, nU);
            self.P = [];
        end

        % get parms  
        function z = nU(self), z = size(self.M,1); end
        function z = nP(self), z = size(self.P,2); end

        % functions we can define here
        function AddPatterns(self, P0, alpha)
            if nargin == 2, alpha = 1; end
            for iP = 1:size(P0,2)
                self.AddOnePattern(P0(:,iP), alpha);
            end
        end   
        
        % baseline matrices
        function InitializeMatrix(self, z)
            if nargin==2 && ischar(z) || isstring(z)
                Z = load(z);
                assert(Z.nU == self.nU, 'stored nUnits [%d] is not the same as current nUnits [%d]', Z.nU, self.nU);
                self.M = Z.M0(randi(length(Z.M0), self.nU, self.nU));
            else
                self.myInitializeMatrix(z);
            end
        end
        
        function myInitializeMatrix(self, ~)
            self.M = zeros(nU, nU);
        end

    end
        
    methods (Abstract)
        AddOnePattern(self, P0, alpha)         
        X = Recall(self, X) 
    end
        
    methods (Static, Abstract)
        P = MakePatterns(nP, nU)        
        P = AddNoise(nP, nU, eta)      
        S = PatternSimilarity(P0,P1);
    end    

    methods (Static)
        function SaveBaselineMatrix(constructor, nP, nU)
            % call with @constructor, nP, nU          
            H = constructor(nU);
            fn = sprintf('%s-BaselineStore.mat', H.myName);
            P = H.MakePatterns(nP, nU);
            H.AddPatterns(P);
            M0 = H.M(:);
            save(fn, 'M0', 'nU', 'nP');
            fprintf('Wrote M0 with %d patterns and %d units to %s.\n', nP, nU, fn);
        end
    end
    
end
        