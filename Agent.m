classdef Agent < handle
    
    properties
        H; % hopfield net for memory 
        T; % ExperientialTimeline (includes past and future)
        wHA; % weight matrix from H to A
        baselineAlpha = 0.0001; % baseline storage for all experiences
        nBase = 25;     
        
        timelineEvents = {};
        % ImposeFlood TS alpha cost
        % RemindFlood TS floodTS
        % Alleviatememory TS floodTS alpha
    end
    
    methods
        function self = Agent(varargin)
            self.T = feval(@MemoryTimeline,varargin{:});
            self.H = Hopfield(self.T.T, self.baselineAlpha);
            self.wHA = zeros(1,self.H.nU);    
            self.baselineStore();
        end
        
        function AddEventToList(self, E)
            self.timelineEvents{end+1} = E;
        end
        
        function baselineStore(self)
            for iT = randi(self.T.nSteps, self.nBase,1)
                P = self.T.getPattern(iT);
                self.H.AddOnePattern(P, 1.0);
            end
        end
        
        % --- 
        % run timeline
        function A = runTimeline(self)
            A = nan(self.T.nSteps,1);
            eventTS = cellfun(@(x) x{2}, self.timelineEvents, 'UniformOutput', true);  % get times to act
            for iT = 1:self.T.nSteps                
                %h = waitbar(iT/self.T.nSteps);
                f = find(iT==eventTS);
                if ~isempty(f)
                    for iF = 1:length(f)
                        feval(self.timelineEvents{f(iF)}{1}, self.timelineEvents{f(iF)}{2:end});
                    end
                end
                 
                P = self.T.getPattern(iT);
                P0 = self.H.Recall(P);
                A(iT) = P0*self.wHA';
                
            end
            %delete(h);
            
            for iA = 2:length(A)
                if isnan(A(iA)), A(iA) = A(iA-1); end
            end
            
        end
        
        % -- events
        
        function ImposeFlood(self, TS, alpha, cost)
            % TS = timestamp ("time of the flood")
            % alpha = salience
            self.H.AddOnePattern(self.T.T(TS:end,:), self.baselineAlpha);
            P = self.T.getPattern(TS);            
            self.H.AddOnePattern(P, alpha);
            % cost = experienced cost
            self.wHA = self.wHA + P.*cost/self.H.nU;
        end
        
        function RemindFlood(self, TS, floodTS)
            % recall flood
            P_now = self.T.getPattern(TS);
            P_then = self.T.getPattern(floodTS);
            P_recall_start = cat(2,P_now(1:self.T.nT0),P_then(self.T.nT0 + (1:self.T.nF)));
            P_recalled = self.H.Recall(P_recall_start);
            % recall cost
            rememberedCost = P_recalled * self.wHA';            
            % impose on present
            self.wHA = self.wHA + P_now.*rememberedCost/self.H.nU;
        end
        
        function AlleviateMemory(self, floodTS, alpha)
            % recall flood
            P_then = self.T.getPattern(floodTS);
            P_recalled = self.H.Recall(P_then);
            % recall cost
            rememberedCost = P_recalled * self.wHA';            
            % alleviate
            self.wHA = self.wHA - alpha * P_recalled.*rememberedCost/self.H.nU;
        end
            

        
    end
end    