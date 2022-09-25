function R = Test_Framing(constructor, varargin)

% Hypothesis is that given two equally likely candidates, adding a little
% to one side or the other produces an increased likelihood of falling into
% that basin.
%
% R = Test_Framing(constructor, nB)

nB = 25;
nU = 500;
nProp = 50;
process_varargin(varargin);

R.nU = nU;
R.nB = nB;

p1 = floor([linspace(0.1,0,nProp) zeros(1,nProp)] * nU);
p2 = floor([zeros(1,nProp) linspace(0,0.1,nProp)] * nU);
np = nProp*2;

R.p1 = p1;
R.p2 = p2;

S = nan(nB, np, 2);
for iB = 1:nB
    M = constructor(nU);
    R.memoryType = M.myName;
    
    P = M.MakePatterns(2,nU);
    M.AddPatterns(P);
    for iP = 1:np
        P0 = M.MakePatterns(1,nU);
        P0(1:p1(iP)) = P(1:p1(iP),1);
        P0(1+nU-(p2(iP):-1:1)) = P(1+nU-(p2(iP):-1:1),2);
        PR = M.Recall(P0);
        %plot(P0,P(:,1),'.', P0, P(:,2), '.'); axis([-0.2 0.2 -0.2 0.2]); drawnow;
        S(iB,iP,:) = M.PatternSimilarity(P, PR);
    end
end
R.S = S;

