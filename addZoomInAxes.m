function [rectHandle, targetAxes] = addZoomInAxes( axesHandle )
% ADDZOOMINAXES adds in an axes that 'zoom-in' to a portion of the existing axes
%
%   Input: 
%       axesHandle: the handle to which the zoom-in plot is used 
% 
% 

if nargin ~= 1 
    fprintf('Must provide an axes object as the only input parameter.\n'); return;
elseif ~ishandle(axesHandle) 
    ME = MException('ZoomInPlot:incorrectInput', 'Input to addZoomInAxes() must be a handle.', axesHandle);
    throw(ME);
elseif ~strcmp(get(axesHandle,'type'), 'axes')
    ME = MException('ZoomInPlot:incorrectInput', 'Input to addZoomInAxes() must be an axeshandle.', axesHandle);
    throw(ME);
end 


% pause for one second so the modal dialog does not appear up right after
% the plot is made even it is called immediately after
pause(0.5);

figureHandle = get(axesHandle, 'parent');

% focus on the current figure
figure( figureHandle );

allChildrenOjbects = allchild(axesHandle); % store all children object for late copy


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


%% register the call backs 
% add a sub function as callback to position change 
% after the target axes is drawn 
addNewPositionCallback(targetRect,  @updateTargetAxes  ) ;
addNewPositionCallback(sourceRect,  @updateSourceRect  ) ;

% call it once manually so that the limits within are set properly 
updateSourceRect( getPosition( sourceRect) );

set(targetAxes, 'xtick', [], 'ytick', []);

box on;

% update the limits in the targetAxes based on the new psotion.
% how do you pass the axes handle into the









%% Confirm and clean up

% prompt to draw another box
waitfor( helpdlg({'You can now move/resize the rectangles.', 'When done, click OK.'}, 'Done') );


% clean up the order of the ui stack
% uistack(rectHandle, 'bottom');
axes(axesHandle); % focus on the axesHandle to place down the rect 
rectHandle = rectangle('Position',getPosition( sourceRect), 'EdgeColor', 'r');
set(rectHandle, 'linestyle','--');

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



    % update the source rect 
    function updateSourceRect (pos)
        % do the necessary updates whenever the sourceRect is moved/resized 
        % things to update if the position of the source rectangle is updated
        % rectHandle
        % first of all, the content of the target axes
        
        set(targetAxes, 'xlim', [pos(1), pos(1) + pos(3)], ...
            'ylim', [pos(2), pos(2) + pos(4)] );
        
    end

end
