function [rectHandle, targetAxes] = addZoomInAxes( axesHandle )
% ADDZOOMINAXES adds in an axes that 'zoom-in' to a portion of the existing axes
%
% Input: 
%   axesHandle - the handle to which the zoom-in plot is used 
% 
% Outputs: 
%   rectHandle - the rectangle that highlight the source area 
%   targetAxes - the axes that depicts the source area 
%  
% Author: Wei Shang (wei.shang@unb.ca)
% May, 2015 

%% Input argument check 
if nargin ~= 1 || ~ishandle(axesHandle)  || ~strcmp(get(axesHandle,'type'), 'axes')
    ME = MException('ZoomInPlot:incorrectInput', 'Input to addZoomInAxes() must be an axeshandle.', axesHandle);
    throw(ME);
end 

%% Prepare work  
% pause for half a second so the dialog does not appear up right after
% the plot is made 
pause(0.5);

figureHandle = get(axesHandle, 'parent');

% focus on the current figure
figure( figureHandle );

% store all children object for copy later
allChildrenOjbects = allchild(axesHandle); 


%% soruce area selection 
% prompt the user to select an area in the current axes
waitfor( helpdlg('Select the area to zoom in', 'Source area selection') );

% trigger the rect drawing tool
sourceRect = imrect( axesHandle );


%% target area 
% prompt to draw another box
waitfor( helpdlg('Select an area to place the zoom plot', 'Target area selection') );

% trigger the rect drawing tool
targetRect = imrect( axesHandle ) ;

normalizedPosition = data2normalized( axesHandle, getPosition(targetRect));
targetAxes = axes('position', normalizedPosition, 'hittest', 'off');

copyobj(allChildrenOjbects, targetAxes);
set(targetAxes, 'xtick', [], 'ytick', []); box on;

%% register the callbacks 
% add a sub function as callback to position change 
% after the target axes is drawn 
addNewPositionCallback(targetRect,  @updateTargetAxes  ) ;
addNewPositionCallback(sourceRect,  @updateSourceRect  ) ;

% call it once manually so that the limits within are set properly 
updateSourceRect( getPosition( sourceRect) );



%% Confirm and clean up

% prompt to draw another box
waitfor( helpdlg({'You can now move/resize the rectangles.', 'When done, click OK.'}, 'Done') );


% clean up the order of the ui stack
axes(axesHandle); % focus on the axesHandle to place down the rect 
rectHandle = rectangle('Position',getPosition( sourceRect), 'linestyle','--',  'EdgeColor', 'r' );

uistack(targetAxes, 'bottom');
uistack(axesHandle, 'bottom');
% remove the imrect objects
delete(sourceRect);
delete(targetRect);


%% sub functions 

    % update the targetAxes location when the targetRect moves 
    function updateTargetAxes(pos)
        
        normalizedPosition = data2normalized( axesHandle, pos);
        set( targetAxes ,'position', normalizedPosition);
        
    end

    % update the content of the target axes when sourceRect's position changes
    function updateSourceRect(pos)
        set(targetAxes, 'xlim', [pos(1), pos(1) + pos(3)], ...
            'ylim', [pos(2), pos(2) + pos(4)] );
    end

end
