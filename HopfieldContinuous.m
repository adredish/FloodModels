classdef HopfieldContinuous < Hopfield
    
    % add AddOnePattern
    
    properties
        beta = 0.1;        
       
        dt = 0.01; invDT = 100;
        sigmoidX = -10:0.01:10;
        sigmoidY = nan;
        
        epsilon = 0.01;  % stopping criterion for recall

    end
    
    methods
        
        function self  = HopfieldContinuous(varargin)
            self = self@Hopfield(varargin{:});
                        
            self.sigmoidY = tanh(self.beta * self.sigmoidX);
            
            self.sigmoid = @self.tanh;
            self.stoppingCriterion = @(X,X0)sum((X-X0).^2) < self.epsilon;

        end       
        
        function y = tanh(self, x)
            if x < self.sigmoidX(1)
                y = -1;
            elseif x > self.sigmoidX(end)
                y = +1;
            else
                y = self.sigmoidY(floor(1+(x - self.sigmoidX(1))*self.invDT));
            end                
        end                
    end
    
    methods(Static)
        function Test
            P = Hopfield.MakePattern(3,100,0.5);
            H = HopfieldContinuous(P);
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
            H = HopfieldContinuous(P, [1; alpha]);
            D = nan(nB,nP);
            for iB = 1:nB
                X = H.Recall(P(1,:)+P(2,:));
                D(iB,:) = H.DistanceToPatterns(X);
            end
            hist(D); legend('P1','P2'); xlabel('distance to pattern');
        end
        
        function [D1,Dn] = TestAddPattern(alpha, tau)
            if nargin==0; alpha = 1; end
            if nargin<2; tau = 0; end
            nB = 10;
            nU = 100; nP = 30; D1 = nan(nP,1);  Dn = nan(nB,nP);
            for iB = 1:nB
                P = Hopfield.MakePattern(nP, nU, 0.5);
                H = HopfieldContinuous(P(1,:), alpha);
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