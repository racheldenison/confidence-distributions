function initial_instructions(window, width, height, contrast)

block_size = 40;
wrapat = 60;

allData.number_attended_fa = 0;
allData.number_attended_cr = 0;
allData.number_attended_hit = 0;
allData.number_attended_miss = 0;
allData.number_unattended_fa = 0;
allData.number_unattended_cr = 0;
allData.number_unattended_hit = 0;
allData.number_unattended_miss = 0;

%Hello
text = 'Thank you for you participation in the current study!\n\nWe are interested in people''s ability to detect different stimuli.\n\nPress any key to continue.';
DrawFormattedText(window, text, 300, 'center', 255, wrapat);
Screen('Flip',window);
WaitSecs(1);
KbWait;

%Here's how the noise background looks like
text = 'In this study you''ll be required to constantly fixate on a small red square in the center of the screen. In each trial you will see four circles that will consist of random noise and superimposed gratings tilted left or right on top of them.\n\nPress any key to see how the circles with superimposed tilted gratings look like.';
DrawFormattedText(window, text, 300, 'center', 255, wrapat);
Screen('Flip',window);
WaitSecs(1);
KbWait;

for i=1:2
    %Show grating
    stimulus_matrix = makeStimulus(window, .3);
    ready_stimulus = Screen('MakeTexture', window, stimulus_matrix);

    %Draw the central square and the stimulus
    if i==1
        rotation_angle = 45;
    else
        rotation_angle = 135;
    end
    Screen('DrawTexture', window, ready_stimulus, [], [], rotation_angle);
    Screen('Flip', window);
    WaitSecs(.3);
    Kbwait;
end

%Set up
text = 'In the actual experiment you will always see 4 circles. An arrow will point to two of the circles in one of the diagonals. In each diagonal the circles will contain gratings tilted either left or right with both circles in the same diagonal containing gratings of the same orientation. Pay special attention to the pointed diagonal as you will be asked to indicate the orientation of the grating in that diagonal on 70% of the trials. In 30% of the trials you will be asked to indicate the orientation of grating in the diagonal that was not pointed.\n\nPress any key to continue.';
DrawFormattedText(window, text, 300, 'center', 255, wrapat);
Screen('Flip',window);
WaitSecs(1);
KbWait;

%Easy examples
text = 'Let''s now do some example trials at high contrast for the gratings at which it should be easier to do the task.\n\nRemember to always fixate on the small square in the center of the screen. The arrow will always point to the same diagonal within a single block of trials.\n\nYour job will be to indicate the orientation of the grating of the two circles that remain on the screen after the presentation (which will always be from the same diagonal). Use the keys ''1'' and ''2''. After indicating the orientation of the gratings, a second question will ask you to rate the visibility of the gratings with 4 options. For now, you will probably use only the "high visibility" option but later on the gratings will become less visible.\n\nPress any key to continue.';
DrawFormattedText(window, text, 300, 'center', 255, wrapat);
Screen('Flip',window);
WaitSecs(1);
KbWait;
data_training = one_block(window, width, height, [.5 .5 .5 .5], block_size, .7, allData);

%Feedback
mistakes = num2str(100*data_training.number_incorrect/block_size);
message = ['In this block you answered incorrectly on ' mistakes '% of the questions'];
Screen ('DrawText', window, message, width/2-200, height/2-50, 255);
Screen('Flip',window);
WaitSecs(1);
KbWait;

%Relatively easy examples
text = 'You might have found it a little strange to rate the visibility when all the stimuli had such a high contrast. In this block you will practice with contrasts that are closer to what you will experience in the actual experiment (just a bit higher). Please, try to adjust your answers to the visibility question so that you use all 4 visibility ratings as much as possible.\n\nIMPORTANT! In indicating the visibility, please rate the visibility of the orientation of the bar, rather than the bar itself.\n\nTry to remember the tilt that each key represents and gradually answer without looking at the question. Press ''1'' if the tilt was top-left to bottom-right. Press ''2'' if the tilt was top-right to bottom-left.\n\nPress any key to continue.';
DrawFormattedText(window, text, 300, 'center', 255, wrapat);
Screen('Flip',window);
WaitSecs(1);
KbWait;
data_training = one_block(window, width, height, repmat(contrast(end),1,4), block_size, .7, allData);

%Feedback
mistakes = num2str(100*data_training.number_incorrect/block_size);
message = ['In this block you answered incorrectly on ' mistakes '% of the questions'];
Screen ('DrawText', window, message, width/2-200, height/2-50, 255);
Screen('Flip',window);
WaitSecs(1);
KbWait;

%Difficult examples (1)
text = 'Take a short break and let''s do some more example trials.\n\nThese trials will be exactly like the trials in the actual experiment.\n\nPress any key to continue.';
DrawFormattedText(window, text, 300, 'center', 255, wrapat);
Screen('Flip',window);
WaitSecs(1);
KbWait;
% contrast = [.06 .08 .1 .12]; 
data_training = one_block(window, width, height, contrast, block_size, .7, allData);

%Feedback
mistakes = num2str(100*data_training.number_incorrect/block_size);
message = ['In this block you answered incorrectly on ' mistakes '% of the questions'];
Screen ('DrawText', window, message, width/2-200, height/2-50, 255);
Screen('Flip',window);
WaitSecs(1);
KbWait;

%Difficult examples (2)
text = 'Take a short break and let''s do one final block of practice trials that will look exactly like the actual experiment. Make sure that as much as possible you are using all 4 visibility levels.\n\nPress any key to continue.';
DrawFormattedText(window, text, 300, 'center', 255, wrapat);
Screen('Flip',window);
WaitSecs(1);
KbWait;
data_training = one_block(window, width, height, contrast, block_size, .7, allData);

%Feedback
mistakes = num2str(100*data_training.number_incorrect/block_size);
message = ['In this block you answered incorrectly on ' mistakes '% of the questions'];
Screen ('DrawText', window, message, width/2-200, height/2-50, 255);
Screen('Flip',window);
WaitSecs(1);
KbWait;