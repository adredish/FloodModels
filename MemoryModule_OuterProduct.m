classdef MemoryModule_OuterProduct < MemoryModule
    
    % implements outer product CAM from Kahana 2020 (equation 5)
    %
    % patterns are Gaussian random normalized to inner product to 1.0
    % two random patterns are effectively inner product 0.0
    
    
    properties        
    end
    
    methods                     
        function z = myName(~), z = 'MemoryModule_OuterProduct'; end

        % general methods
        function AddOnePattern(self, P0, alpha)
            if nargin == 2, alpha = 1; end
            P0 = self.renorm(P0);
            self.M = self.M + alpha * (P0 * P0'); % memory pattern: outer product            
            if self.FLAG_keepTrackOfPatterns
                self.P = cat(2, self.P, P0);
            end
        end
              
        function X = Recall(self, X)
            X = self.renorm(X);
            X = self.M * X;
            X = self.renorm(X);
        end
               
    end
    
    methods(Static)
        
        function P = MakePatterns(nP, nU)
            P = randn(nU, nP);
            P = MemoryModule_OuterProduct.renorm(P);
        end
        
        function P = renorm(P)
            [~,nP] = size(P);
            for iP = 1:nP
                P(:,iP) = P(:,iP)/norm(P(:,iP));
            end
        end
        
        function P = AddNoise(P, eta)
            P = P + eta * randn(size(P));
            P = MemoryModule_OuterProduct.renorm(P);
        end
        
        function D = PatternSimilarity(P, X)
            if nargin==1
                nP = size(P,2);
                D = corrcoef(P);
            else
                P0 = cat(2, X, P);
                nX = size(X,2);
                D = corrcoef(P0);
                D = D((nX+1):end,1:nX);                
            end
        end                         
        
    end
end