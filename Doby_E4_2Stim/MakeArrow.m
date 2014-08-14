[window,width,height] = openScreen();

Screen ('FillRect', window, 127);

length = degrees2pixels(2);
arrow_length = degrees2pixels(.7);

Screen('Drawline', window, 255, width/2-length/2, height/2, width/2+length/2, height/2, 5);

Screen('FillRect', window, 255, [width/2+length/2, height/2-arrow_length, width/2+length/2+arrow_length, height/2+arrow_length]);

Screen('FillRect', window, 255, [width/2-length/2-arrow_length, height/2-arrow_length, width/2-length/2, height/2+arrow_length]);

Screen('FillPoly', window, 127, [width/2+length/2, height/2-arrow_length; width/2+length/2+arrow_length, height/2; width/2+length/2+arrow_length, height/2-arrow_length]);
Screen('FillPoly', window, 127, [width/2+length/2, height/2+arrow_length; width/2+length/2+arrow_length, height/2; width/2+length/2+arrow_length, height/2+arrow_length]);
Screen('FillPoly', window, 127, [width/2-length/2, height/2-arrow_length; width/2-length/2-arrow_length, height/2; width/2-length/2-arrow_length, height/2-arrow_length]);
Screen('FillPoly', window, 127, [width/2-length/2, height/2+arrow_length; width/2-length/2-arrow_length, height/2; width/2-length/2-arrow_length, height/2+arrow_length]);

arrowMatrix=Screen('GetImage', window, [width/2-length/2-arrow_length, height/2-arrow_length, width/2+length/2+arrow_length, height/2+arrow_length], 'backBuffer');

Screen('Flip', window);

save arrow arrowMatrix;

KbWait;

sca;