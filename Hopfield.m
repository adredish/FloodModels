classdef Hopfield < handle
    
    % add AddOnePattern
    
    properties
        eta = 1; % noise, chance of flipping anyway
        tau = 0; % decay rate of memory when adding new patterns
        
        W  % weight matrix
        P % stored patterns
        
        sigmoid = @sign;
        stoppingCriterion = @(X,X0)all(X==X0);
        
        display = false;
    end
    
    methods
        % constructor
        function self  = Hopfield(varargin)
            if length(varargin) == 1 && length(varargin{1})==1 % nU
                nU = varargin{1};
                self.W = zeros(nU, nU);
                self.P = nan(1,nU);
            else  % P or P, alpha
                if length(varargin) == 2 % P, alpha
                    P = varargin{1}; A = varargin{2};
                elseif length(varargin) == 1 % just P
                    P = varargin{1}; A = ones(size(P,1),1);
                end
                self.P = P;
                self.TrainFromZero(P, A);
            end
        end
        
        % parms
        function u = nU(self), u = size(self.P,2); end
        function p = nP(self), p = size(self.P,1); end
        
        % general methods
        function TrainFromZero(self, P, alpha)
            % P is a set of nP x nU patterns and
            % alpha is a set of nP weights
            [nP, nU] = size(P); assert(nU == self.nU);
            assert(size(alpha,1)==nP || size(alpha,1)==1); assert(size(alpha,2)==1);
            P(P<=0) = -1; P(P>0) = +1;  % Hopfield
            
            self.W = (alpha .* P)' * P;
            self.W = self.W - eye(self.nU).*self.W;
            self.P = P;
            
            if self.display
                clf;
                subplot(211); hold off; plot(nan, nan); hold on; bar(self.P'); title('patterns'); ylim([0 1]);
                subplot(212); imagesc(self.W); title('weights');
            end
        end
        
        function AddOnePattern(self, P, alpha)
            [nP, nU] = size(P); assert(nU == self.nU);
            assert(size(alpha,1)==nP || size(alpha,1)==1); assert(size(alpha,2)==1);
            self.W = (1-self.tau) * self.W + (alpha .* P)' * P;
            self.W = self.W - eye(self.nU).*self.W;
            if all(isnan(self.P)), self.P = P;
            else, self.P = cat(1, self.P, P); end
            if self.display
                clf;
                subplot(211); hold off; plot(nan, nan); hold on; bar(self.P'); title('patterns'); ylim([0 1]);
                subplot(212); imagesc(self.W); title('weights');
            end
            
        end
        
       
        function X = Recall(self, X0)
            
            function ShowOneStep(X)
                for iP = 1:self.nP
                    subplot(self.nP,1,iP);
                    hold off; bar(X); hold on
                    plot(self.P(iP,:), 'o-', 'MarkerSize', 10, 'LineWidth', 2);
                    ylim([-1 1]);
                    fprintf('%5.2f ', self.DistanceToPatterns(X)); fprintf('\n');
                    drawnow; pause(0.1);
                end
            end
            
            % X0 is a 1 x nU pattern
            X = X0;
            if self.display, ShowOneStep(X); end
            
            for iT = 1:500
                samples = randperm(self.nU);
                for iX = samples
                    U = self.W(iX,:) * X';
                    X(iX) = self.sigmoid(U + self.eta * randn(size(U)));
                end
                
                if self.display, ShowOneStep(X); title(num2str(iT)); end
                
                if self.stoppingCriterion(X,X0)
                   break;
                else
                    X0=X;                    
                end
            end
        end
        
        function D = DistanceToPatterns(self, X0)
            D = sum((X0-self.P).^2,2);
        end
        
        function R = RandPattern(self)
            R = 2*rand(1,self.nU)<0.5-1;
        end
    end
    
    methods(Static)
        function P = MakePattern(nP, nU, p)
            P = 2*double(rand(nP, nU)<p)-1;
        end
        
        function ShowPattern(P)
            P(P==-1) = 0;
            [nP,nU] = size(P); %#ok<*ASGLU>
            for iP = 1:nP
                fprintf('%1d',P(iP,:));fprintf('\n');
            end
        end
        
        function P = AddNoise(P, eta)
            [nP, nU] = size(P);
            nFlip = ceil(eta * nU);
            toFlip = randi(nU, nP, nFlip);
            for iP = 1:nP
                P(iP,toFlip) = -P(iP,toFlip);
            end
        end
        
        function Test
            P = Hopfield.MakePattern(3,100,0.5);
            H = Hopfield(P);
            for iP = 1:size(P,1)
                X = H.Recall(H.AddNoise(P(iP,:),0.2));
                fprintf('Recall P%02d:  ', iP);                
                fprintf('%.2f ', H.DistanceToPatterns(X)); fprintf('\n');
            end
        end
        
        function AlphaTest(alpha)
            if nargin==0, alpha = 1; end
            nB = 200; nU = 100; nP = 2;
            P = Hopfield.MakePattern(nP,nU,0.5);
            H = Hopfield(nU);
            H.display = false;
            H.TrainFromZero(P, [1;alpha]);
            D = nan(nB,nP);
            for iB = 1:nB
                X = H.Recall(P(1,:)+P(2,:));
                D(iB,:) = H.DistanceToPatterns(X);
            end
            hist(D); legend('P1','P2'); xlabel('distance to pattern');
        end
        
        function D = TestPattern
            nU = 100; nP = 25; D = nan(nP);
            for iP = 1:nP
                P = Hopfield.MakePattern(iP, nU, 0.5);
                H = Hopfield(P);
                X = H.Recall(P(1,:));
                D(iP,1:iP) = H.DistanceToPatterns(X);
            end
        end
        function [D1,Dn] = TestAddPattern(alpha, tau)
            if nargin==0; alpha = 1; end
            if nargin<2; tau = 0; end
            nB = 10;
            nU = 100; nP = 30; D1 = nan(nP,1);  Dn = nan(nB,nP);
            for iB = 1:nB
                P = Hopfield.MakePattern(nP, nU, 0.5);
                H = Hopfield(P(1,:), alpha);
                H.tau = tau;
                h = waitbar(iB./nB);
                for iP = 2:nP
                    H.AddOnePattern(P(iP,:),1);
                    X = H.Recall(P(1,:));
                    D0 = H.DistanceToPatterns(X); D1(iB,iP) = D0(1);
                    X = H.Recall(P(iP,:));
                    D0 = H.DistanceToPatterns(X); Dn(iB,iP) = D0(iP);
                end
            end
            delete(h)
            
            clf;
            errorbar(1:30, nanmean(D1), nanstd(D1)/sqrt(nP));
            hold on
            errorbar(1:30, nanmean(Dn), nanstd(Dn)/sqrt(nP));
            ylim([0 100]); xlabel('num patterns'); ylabel('distance to pattern'); legend('P1','Pn','Location','nw')
            
        end
        
        
    end
end