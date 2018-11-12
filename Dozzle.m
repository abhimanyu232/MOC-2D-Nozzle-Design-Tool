function l=Dozzle(handles)

G=str2num(get(handles.gamma,'string')); %Specific heat Ratio
if isempty(G)
 G = 1.4;
end
Me=str2num(get(handles.Input,'string')); %exit Mach Number
n=str2num(get(handles.waves,'string'));  %finite Number of Waves used for calculation
if isempty(n)
  n =16;
end
  
Km = zeros(n,n);    % K- vlaues (Constant along right running characteristic lines)
Kp = zeros(n,n);    % K- vlaues (Constant along left running characteristic lines)
Theta = zeros(n,n); % Flow angles relative to the horizontal
Mu = zeros(n,n);    % Mach angles
M = zeros(n,n);     % Mach Numbers
x = zeros(n,n);     % x-coordinates
y = zeros(n,n);     % y-coordinates

%% Find NuMax (maximum expansion angle)
[~, ThetaMax, ~] = PMF(G,Me,0,0); % Prandtl meyer Angle
NuMax = ThetaMax/2; %Maximum characteristic Wave Angle

%% Define some flow parameters of originating characteristic lines
dT = NuMax/n; %angle increment  
ThetaArc(:,1) = (0:dT:NuMax); %array of characteristic line angles 

NuArc = ThetaArc;
KmArc = ThetaArc + NuArc; %Right Running Characteristic Angles
[~, ~, MuArc(:,1)] = PMF(G,0,NuArc(:,1),0); %Mach Angle for every wave

%% Coordinates of wall along curve from throat
y0 = 1; % Define throat half-height
if get(handles.enter,'value')==1
ThroatCurveRadius =0;
else
cr=str2num(get(handles.edit4,'string')); %get radius multiplier from user
    if isempty(cr)
     cr =3;
    end
    ThroatCurveRadius =cr*y0;  % Radius of curvature just downstream of the throat
end
[xarc, yarc] = Arc(ThroatCurveRadius,ThetaArc); % Finds x- and y-coordinates for given theta-values
yarc(:,1) = yarc(:,1) + y0; % Defines offset due to arc being above horizontal

%% Fill in missing datapoint info along first C+ line
% First centerline datapoint done manually
Km(:,1) = KmArc(2:length(KmArc),1);
Theta(:,1) = ThetaArc(2:length(KmArc),1);
Nu(:,1) = Theta(:,1);
Kp(:,1) = Theta(:,1)-Nu(:,1);
M(1,1) = 1;
Nu(1,1) = 0;
Mu(1,1) = 90;
y(1,1) = 0;
x(1,1) = xarc(2,1) + (y(1,1) - yarc(2,1))/tand((ThetaArc(2,1) - MuArc(2,1) - MuArc(2,1))/2);

% Finds the information at interior nodes along first C+ line
for i=2:n

        [M(i,1), Nu(i,1), Mu(i,1)] = PMF(G,0,Nu(i,1),0); 
        s1 = tand((ThetaArc(i+1,1) - MuArc(i+1,1) + Theta(i,1) - Mu(i,1))/2);
        s2 = tand((Theta(i-1,1) + Mu(i-1,1) + Theta(i,1) + Mu(i,1))/2);
        x(i,1) = ((y(i-1,1)-x(i-1,1)*s2)-(yarc(i+1,1)-xarc(i+1,1)*s1))/(s1-s2);
        y(i,1) = y(i-1,1) + (x(i,1)-x(i-1,1))*s2;
        
end

%% Find flow properties at remaining interior nodes
for j=2:n;
    for i=1:n+1-j;
        
        Km(i,j) = Km(i+1,j-1);
        
        if i==1;
            
            Theta(i,j) = 0;
            Kp(i,j) = -Km(i,j);
            Nu(i,j) = Km(i,j);
            [M(i,j), Nu(i,j), Mu(i,j)] = PMF(G,0,Nu(i,j),0);
            s1 = tand((Theta(i+1,j-1)-Mu(i+1,j-1)+Theta(i,j)-Mu(i,j))/2);
            x(i,j) = x(i+1,j-1) - y(i+1,j-1)/s1;
            y(i,j) = 0;
            
        else
            
            Kp(i,j) = Kp(i-1,j);
            Theta(i,j) = (Km(i,j)+Kp(i,j))/2;
            Nu(i,j) = (Km(i,j)-Kp(i,j))/2;
            [M(i,j), Nu(i,j), Mu(i,j)] = PMF(G,0,Nu(i,j),0);
            s1 = tand((Theta(i+1,j-1)-Mu(i+1,j-1)+Theta(i,j)-Mu(i,j))/2);
            s2 = tand((Theta(i-1,j)+Mu(i-1,j)+Theta(i,j)+Mu(i,j))/2);
            x(i,j) = ((y(i-1,j)-x(i-1,j)*s2)-(y(i+1,j-1)-x(i+1,j-1)*s1))/(s1-s2);
            y(i,j) = y(i-1,j) + (x(i,j)-x(i-1,j))*s2;
            
        end
          
    end
end

%% Find wall node information
xwall = zeros(2*n,1);
ywall = xwall;
ThetaWall = ywall;

xwall(1:n,1) = xarc(2:length(xarc),1);
ywall(1:n,1) = yarc(2:length(xarc),1);
ThetaWall(1:n,1) = ThetaArc(2:length(xarc),1);
for i=1:n-1
    ThetaWall(n+i,1) = ThetaWall(n-i,1);
end

for i=1:n
    
    s1 = tand((ThetaWall(n+i-1,1) + ThetaWall(n+i,1))/2);
    s2 = tand(Theta(n+1-i,i)+Mu(n+1-i,i));
    xwall(n+i,1) = ((y(n+1-i,i)-x(n+1-i,i)*s2)-(ywall(n+i-1,1)-xwall(n+i-1,1)*s1))/(s1-s2);
    ywall(n+i,1) = ywall(n+i-1,1) + (xwall(n+i,1)-xwall(n+i-1,1))*s1;
        
end

%% Provide wall geometry to user
assignin('caller','xwall',xwall) %store x coordinates in workspace
assignin('caller','ywall',ywall) %store y coordinates in workspace

if ThroatCurveRadius == 0
    q=[0 1 ;xwall((length(xwall)/2)+1:length(xwall),1) ywall((length(ywall)/2)+1:length(ywall),1)]; %store data to pass to GUI
    t = xlsread('temp_data.xlsx');
if ~isempty(t)
    xlswrite('temp_data.xlsx',zeros(size(t))*nan);
end
xlswrite('temp_data.xlsx',q)
else
    q=[0 1 ;xwall ywall]; %store data to pass to GUI
t = xlsread('temp_ideal.xlsx');
if ~isempty(t)
    xlswrite('temp_ideal.xlsx',zeros(size(t))*nan);
end

xlswrite('temp_ideal.xlsx',q) %write coordinate data to excel sheet
end
%%
% Draw contour and characteristic web
  if ThroatCurveRadius == 0
  w=3;
  else w=2;
  end
  
  figure(w);clf(w);    hold on

    plot(xwall,ywall,'-')
     %plot nozzle contour
    axis image
   %axis([0 ceil(xwall(length(xwall),1)) 0 ceil(ywall(length(ywall),1))])
    plot(xarc,yarc,'k-')%plot throat arc
    
    for i=1:n-1
        plot(x(1:n+1-i,i),y(1:n+1-i,i),'k-') %left running characteristics complex region
    end

    for i=1:n
        plot([xarc(i,1) x(i,1)],[yarc(i,1) y(i,1)],'k-') %simple region right running characteristics
        plot([x(n+1-i,i) xwall(i+n,1)],[y(n+1-i,i) ywall(i+n,1)],'k-')%unform region left running characteristics
    end

    for c=1:n
        for r=2:n+1-c
            plot([x(c,r) x(c+1,r-1)],[y(c,r) y(c+1,r-1)],'k-')%complex region right running characteristics
        end
    end
    xlabel('Length')
    ylabel('Height ')
%{  %plot mirror   
    figure(w);
    hold on
    plot(xwall,-ywall,'-')
   axis image
   % axis([0 ceil(xwall(length(xwall),1)) 0 ceil(-ywall(length(ywall),1))])
    plot(xarc,-yarc,'k-')%plot throat arc
    
    for i=1:n-1
        plot(x(1:n+1-i,i),-y(1:n+1-i,i),'k-') %left running characteristics complex region
    end

    for i=1:n
        plot([xarc(i,1) x(i,1)],[-yarc(i,1) -y(i,1)],'k-') %simple region right running characteristics
        plot([x(n+1-i,i) xwall(i+n,1)],-[y(n+1-i,i) ywall(i+n,1)],'k-')%unform region left running characteristics
    end

    for c=1:n
        for r=2:n+1-c
            plot([x(c,r) x(c+1,r-1)],[-y(c,r) -y(c+1,r-1)],'k-')%complex region right running characteristics
        end
    end
    

