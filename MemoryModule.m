classdef MemoryModule < handle
    
    % add AddOnePattern
    
    properties
        M  % weight matrix [nU x nU]
        P % stored patterns in order nU x nP
        
        tau=0; % baseweight when adding patterns
        
        patternSimilarityNormalization = [];
    end
    
    methods
        % constructor
        function self  = MemoryModule(nU)
            self.M = zeros(nU, nU);
            self.P = nan(nU,1);
        end
        
        function initializeMatrix(self, z)
            if ischar(z) || isstring(z)
                load(z, 'M0');          
                self.M = M0(randi(length(M0), self.nU, self.nU));
            else
                self.M = randn(self.nU, self.nU) * z;
            end
        end
        
        % parms
        function u = nU(self), u = size(self.P,1); end
        function p = nP(self), p = size(self.P,2); end
        
        % general methods
        function AddOnePattern(self, P0, alpha)
            if nargin == 2, alpha = 1; end
            P0 = self.renorm(P0);
            MP = alpha * P0 * P0'; % memory pattern: outer product
            if isnan(self.P(1)) % first pattern
                self.P = P0;
                self.M = MP;
            else
                self.P = cat(2, self.P, P0);
                self.M = self.M + MP;
            end
        end
        
        function AddPatterns(self, P, alpha)
            [~,nP] = size(P);
            if nargin == 2, alpha = 1; end
            if length(alpha)==1, alpha = repmat(alpha, nP, 1); end
            for iP = 1:nP
                self.AddOnePattern(P(:,iP), alpha(iP));
            end
        end
        
        function X = Recall(self, X)
            X = self.renorm(X);
            X = self.M * X;
            X = self.renorm(X);
        end
               
    end
    
    methods(Static)
        
        % making patterns
        function P = MakePatterns(nP, nU)
            P = randn(nU, nP);
            P = MemoryModule.renorm(P);
        end
        
        function P = renorm(P)
            [~,nP] = size(P);
            for iP = 1:nP
                P(:,iP) = P(:,iP)/norm(P(:,iP));
            end
        end
        
        function P = AddNoise(P, eta)
            [nU, nP] = size(P);
            P = P + eta * randn(size(P));
            P = MemoryModule.renorm(P);
        end
        
        % measuring pattern similarity
        function D = PatternSimilarity(P, X)
            P0 = cat(2, X, P);
            D = corrcoef(P0);
            nX = size(X,2);
            D = D((nX+1):end,1:nX);
        end         
        
        % ==============================================
        % TESTING
        function D = Test(nP, nU, noise)
            if nargin < 3, noise = 0; end
            if nargin < 2, nU = 1000; end
            if nargin < 1, nP = 25; end
            H = MemoryModule(nU);
            P = MemoryModule.MakePatterns(nP,nU);
            H.CalculatePatternSimilarityNorm;
            H.AddPatterns(P);
            D = nan(nP,nP);
            for iP = 1:nP
                P0 = H.AddNoise(P(:,iP), noise);
                X = H.Recall(P0);
                D(iP,:) = H.myPatternSimilarity(X);
            end
        end
        
        function D = TestAlpha(nP, nU, noise, alpha)
            if nargin < 4, alpha = 2; end
            if nargin < 3, noise = 0; end
            if nargin < 2, nU = 1000; end
            if nargin < 1, nP = 25; end
            H = MemoryModule(nU);
            P = MemoryModule.MakePatterns(nP,nU);
            H.CalculatePatternSimilarityNorm;
            H.AddPatterns(P, [alpha, ones(1, nP-1)]);
            D = nan(nP,nP);
            for iP = 1:nP
                P0 = H.AddNoise(P(:,iP), noise);
                X = H.Recall(P0);
                D(iP,:) = H.myPatternSimilarity(X);
            end
        end
        
    end
end