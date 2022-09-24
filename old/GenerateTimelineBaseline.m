function GenerateTimelineBaseline

% generates the baseline memory distribution from a timeline from a typical
% agent

A = AgentM;
for iT = 1:A.T.nSteps
    A.H.AddOnePattern(A.T.getPattern(iT),1); 
end
M0 = A.H.M(:);
%histogram(A.H.M(:))
save MemoryBaseline M0

