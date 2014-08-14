function [conf rt] = scale_question(window, width, height, time)

% Display and set cursor
import java.awt.Robot;
mouse = Robot;
ShowCursor;
mouse.mouseMove(width/2, height - 400);

%Display the question and allow subjects to move the cursor
DrawFormattedText(window, 'How confident are you?', 'center', height-600, 255);
DrawFormattedText(window, 'Not confident at all                                     Very confident', 'center', height-350, 255);
Screen('DrawLine', window, 255, width/2-300, height-400, width/2+300, height-400, 20);
Screen('Flip', window);
GetClicks(0,.00000001);
rt = GetSecs - time;

%Collect the response
PointerLocation = get(0, 'PointerLocation');
if PointerLocation(1) > width/2+300
    conf_scale = width/2+300;
elseif PointerLocation(1) < width/2-300
    conf_scale = width/2-300;
else
    conf_scale = PointerLocation(1);
end
conf = (conf_scale - (width/2-300)) / 600;
HideCursor;

%Display the answer
DrawFormattedText(window, 'How confident are you?', 'center', height-600, 255);
DrawFormattedText(window, 'Not confident at all                                     Very confident', 'center', height-350, 255);
Screen('DrawLine', window, 255, width/2-300, height-400, width/2+300, height-400, 20);
Screen('FillOval', window, [255 0 0], [conf_scale-20, height-400-20, conf_scale+20, height-400+20]);
Screen('Flip', window);
WaitSecs(.2);