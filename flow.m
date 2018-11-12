%% Calculates Flow Properties for the given mach Number
function u=flow(handles)
G=str2num(get(handles.gamma,'string'));
if isempty(G)
  G = 1.4;
end
Me=str2num(get(handles.Input,'string'));
n=str2num(get(handles.waves,'string'));
if isempty(n)
  n =16;
end
pmf=nu(Me,G)/2;
    [mach, T, P, rho, area] = flowisentropic(G, Me, 'mach'); 
    flow=[mach, T, P, rho, area, pmf];
    assignin('base','flow',flow)