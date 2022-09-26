classdef MemoryModule_Hopfield < MemoryModule
    
    properties
        eta = 1;
        sigmoid = @sign;

        maxSteps = 100;
        stoppingCriterion = 0.01;
    end
    
    methods
        function z = myName(~), z = 'MemoryModule_Hopfield'; end
              
        function AddOnePattern(self, P0, alpha)
            if nargin == 2, alpha = 1; end            
            self.M = self.M + alpha * (P0 * P0'); % memory pattern: outer product
            
            if self.FLAG_keepTrackOfPatterns
                self.P = cat(2, self.P, P0);
            end                       
            
        end
        
        function X = Recall(self, X0)
            % note that this is doing each cycle synchronously rather than
            % asynchronously, which Hopfield requires, but asynchronous is
            % incredibly slow.
            X = X0;
            for iStep = 1:self.maxSteps
                X = self.sigmoid(self.M * X0 + self.eta * randn(self.nU,1));
                if mean(abs(X-X0)) < self.stoppingCriterion, break; end
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
            % pattern similarity of random patterns ranges from 0.5 to 1 
            % so need to rescale from 0 to 1
            S = (S-0.5)*2;
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