classdef MemoryModule_Hopfield < MemoryModule
    
    properties
        eta = 1;
        sigmoid = @sign;
        stoppingCriterion = @(X,X0)all(X==X0);
        
        maxSteps = 100;
    end
    
    methods
        function z = myName(~), z = 'MemoryModule_Hopfield'; end
        
        function AddOnePattern(self, P0, alpha)
            if nargin == 2, alpha = 1; end
            MP = alpha * (P0 * P0'); % memory pattern: outer product
            self.M = self.M + MP;
            
            if self.FLAG_keepTrackOfPatterns
                self.P = cat(2, self.P, P0);
            end
            
        end
        
        function X = Recall(self, X0)
            X = X0;
            for iStep = 1:self.maxSteps
                samples = randperm(self.nU);
                for iX = samples
                    U = self.M(iX,:) * X;
                    X(iX) = self.sigmoid(U + self.eta * randn);
                end
                if self.stoppingCriterion(X,X0), break; end
                X0=X;
            end
        end
        
    end
    
    methods(Static)
        function P = MakePatterns(nP, nU)
            P = 2*double(rand(nU, nP)<0.5)-1;
        end
        
        function S = PatternSimilarity(P, X)
            if nargin == 1, X = P;end
            nP = size(P,2); nX = size(X,2);
            S = nan(nP, nX);
            for iP = 1:nP, for iX = 1:nX
                    S(iP,iX) = mean(P(:,iP) == X(:,iX));
                end; end
        end
        
        function P = AddNoise(P, eta)
            P = MemoryModule_Hopfield.Noise_ReplaceRand(P, eta);
            %P = MemoryModule_Hopfield.Noise_FlipRand(P, eta);
        end
        
        function P = Noise_ReplaceRand(P, eta)
            [nP, nU] = size(P);
            randYN = rand(nP,nU) < eta;
            R = MemoryModule_Hopfield.MakePatterns(nP, nU);
            P(randYN) = R(randYN);
        end
        
        function P = Noise_FlipRand(P, eta)
            [nP, nU] = size(P);
            randYN = rand(nP,nU) < eta;
            P(randYN) = -P(randYN);
        end
        
    end
end