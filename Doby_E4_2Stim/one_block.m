function presentation = one_block(window, width, height, contrast, number_trials, percent, allData)

%Left tilt means  \
%Right tilt means /

one = KbName('1!');
two = KbName('2@');
three = KbName('3#');
four = KbName('4$');
nine = KbName('9(');

attended_current.fa = 0;
attended_current.cr = 0;
attended_current.hits = 0;
attended_current.misses = 0;
unattended_current.fa = 0;
unattended_current.cr = 0;
unattended_current.hits = 0;
unattended_current.misses = 0;

%load the central arrow matrix
load arrow;
arrow_image = Screen('MakeTexture', window, arrowMatrix);

diameter = degrees2pixels(5, 50, [], window);
inner = degrees2pixels(1, 50, [], window);

presentation.question_display = randperm(number_trials);
presentation.attended_display = randperm(number_trials);
presentation.unattended_display = randperm(number_trials);

for i=1:number_trials
    %Decide on the contrast of the attended
    if presentation.attended_display(i) > number_trials/2
        display_attended(i) = 1; %display left tilt
    else
        display_attended(i) = 2; %display right tilt
    end

    %Decide on the contrast of the unattended
    if presentation.unattended_display(i) > number_trials/2
        display_unattended(i) = 1; %display left tilt
    else
        display_unattended(i) = 2; %display right tilt
    end
end

number_incorrect = 0;
number_incorrect_attended = 0;
number_incorrect_unattended = 0;
number_correct_attended = 0;
number_correct_unattended = 0;

%Choose the cued diagonal randomly
if rand > .5
    cued_diagonal = 1; %Cue the first diagonal
else
    cued_diagonal = 2; %Cue the second diagonal
end

%Initialize the variables
for i=1:number_trials

    %Choose the questioned diagonal to get 70% correct cue
    if presentation.question_display(i) <= number_trials*percent
        questioned_diagonal(i) = cued_diagonal; %Correct cue
        question_about_attended(i) = 1;
    else
        questioned_diagonal(i) = 3 - cued_diagonal; %Incorrect cue
        question_about_attended(i) = 0;
    end
end

Screen('DrawDots', window, [width/2, height/2], 3, [255,0,0]);
Screen('Flip', window);

WaitSecs(.5);

for i=1:number_trials

    %Choose the contrast randomly
    which_contrast(i) = ceil(4*rand);
    contrast_shown(i) = contrast(which_contrast(i));
    
    %Prepare and flash the stimulus
    if display_attended(i) == 1
        rotation_angle_attended = 135; %display left tilt
    else
        rotation_angle_attended = 45; %display right tilt
    end

    if display_unattended(i) == 1
        rotation_angle_unattended = 135; %display left tilt
    else
        rotation_angle_unattended = 45; %display right tilt
    end

    stimulus_matrix_attended = makeStimulus(window, contrast_shown(i));
    stimulus_matrix_unattended = makeStimulus(window, contrast_shown(i));
    ready_stimulus_attended = Screen('MakeTexture', window, stimulus_matrix_attended);
    ready_stimulus_unattended = Screen('MakeTexture', window, stimulus_matrix_unattended);

    %Draw the cue
    for number_frames=1:30
        if cued_diagonal == 1
            Screen('DrawTexture', window, arrow_image, [], [], 45);
        else
            Screen('DrawTexture', window, arrow_image, [], [], 135);
        end

        %Draw the fixation square and flip
        Screen('DrawDots', window, [width/2, height/2], 10, [255,0,0]);
        Screen('Flip', window);
    end

    %Draw the stimuli
    for number_frames=1:10

        %Draw the 4 circles
        if cued_diagonal == 1
            Screen('DrawTexture', window, ready_stimulus_attended, [], [width/2-inner-diameter, ...
                height/2-inner-diameter, width/2-inner, height/2-inner], rotation_angle_attended);
            Screen('DrawTexture', window, ready_stimulus_attended, [], [width/2+inner, ...
                height/2+inner, width/2+inner+diameter, height/2+inner+diameter], rotation_angle_attended);
            Screen('DrawTexture', window, ready_stimulus_unattended, [], [width/2+inner, ...
                height/2-inner-diameter, width/2+inner+diameter, height/2-inner], rotation_angle_unattended);
            Screen('DrawTexture', window, ready_stimulus_unattended, [], [width/2-inner-diameter, ...
                height/2+inner, width/2-inner, height/2+inner+diameter], rotation_angle_unattended);
        else
            Screen('DrawTexture', window, ready_stimulus_unattended, [], [width/2-inner-diameter, ...
                height/2-inner-diameter, width/2-inner, height/2-inner], rotation_angle_unattended);
            Screen('DrawTexture', window, ready_stimulus_unattended, [], [width/2+inner, ...
                height/2+inner, width/2+inner+diameter, height/2+inner+diameter], rotation_angle_unattended);
            Screen('DrawTexture', window, ready_stimulus_attended, [], [width/2+inner, ...
                height/2-inner-diameter, width/2+inner+diameter, height/2-inner], rotation_angle_attended);
            Screen('DrawTexture', window, ready_stimulus_attended, [], [width/2-inner-diameter, ...
                height/2+inner, width/2-inner, height/2+inner+diameter], rotation_angle_attended);
        end

        %Draw the cue
        if cued_diagonal == 1
            Screen('DrawTexture', window, arrow_image, [], [], 45);
        else
            Screen('DrawTexture', window, arrow_image, [], [], 135);
        end

        %Draw the fixation square and flip
        Screen('DrawDots', window, [width/2, height/2], 10, [255,0,0]);
        Screen('Flip', window);
    end

    %200ms break before the question
    WaitSecs(.2);

    %Ask question
    if questioned_diagonal(i) == 1
        Screen('FrameOval', window, 255, [width/2-inner-diameter, height/2-inner-diameter, ...
            width/2-inner, height/2-inner], 2,2);
        Screen('FrameOval', window, 255, [width/2+inner, height/2+inner, ...
            width/2+inner+diameter, height/2+inner+diameter], 2,2);
    else
        Screen('FrameOval', window, 255, [width/2-inner-diameter, height/2+inner, ...
            width/2-inner, height/2+inner+diameter], 2,2);
        Screen('FrameOval', window, 255, [width/2+inner, height/2-inner-diameter, ...
            width/2+inner+diameter, height/2-inner], 2,2);
    end

    %Display question
    DrawFormattedText(window, 'The tilt of the gratings in the above circles were:', 'center', height-250, 255);
    DrawFormattedText(window, '1: like \ ', 'center', height-200, 255);
    DrawFormattedText(window, '2: like / ', 'center', height-170, 255);
    Screen('DrawDots', window, [width/2, height/2], 10, [255,0,0]);
    time = Screen('Flip', window);

    %Collect response
    while 1
        [keyIsDown,secs,keyCode]=KbCheck;
        if keyIsDown
            if keyCode(one)
                answer = 1;
                break;
            elseif keyCode(two)
                answer = 2;
                break;
            elseif keyCode(nine)
                answer = bbb; %forcefully break out
            end
        end
    end
    rt = secs - time;

    %Wait 200ms to prevent double-reading of the first key press
    WaitSecs(.2);

    %Display the diagonal presented
    if questioned_diagonal(i) == 1
        Screen('FrameOval', window, 255, [width/2-inner-diameter, height/2-inner-diameter, ...
            width/2-inner, height/2-inner], 2,2);
        Screen('FrameOval', window, 255, [width/2+inner, height/2+inner, ...
            width/2+inner+diameter, height/2+inner+diameter], 2,2);
    else
        Screen('FrameOval', window, 255, [width/2-inner-diameter, height/2+inner, ...
            width/2-inner, height/2+inner+diameter], 2,2);
        Screen('FrameOval', window, 255, [width/2+inner, height/2-inner-diameter, ...
            width/2+inner+diameter, height/2-inner], 2,2);
    end

    %Display question
    DrawFormattedText(window, 'How visible was the orientation of the gratings in the above circles?', 'center', height-250, 255);
    DrawFormattedText(window, '1: Highly visible', 'center', height-200, 255);
    DrawFormattedText(window, '2: Somewhat visible', 'center', height-170, 255);
    DrawFormattedText(window, '3: Barely visible', 'center', height-140, 255);
    DrawFormattedText(window, '4: Not visible at all', 'center', height-110, 255);
    Screen('DrawDots', window, [width/2, height/2], 10, [255,0,0]);
    Screen('Flip', window);

    %Collect response
    while 1
        [keyIsDown,secs,keyCode]=KbCheck;
        if keyIsDown
            if keyCode(one)
                answer2 = 1;
                break;
            elseif keyCode(two)
                answer2 = 2;
                break;
            elseif keyCode(three)
                answer2 = 3;
                break;
            elseif keyCode(four)
                answer2 = 4;
                break;
            elseif keyCode(nine)
                answer2 = bbb; %forcefully break out
            end
        end
    end

    %Decide whether answer was correct
    if question_about_attended(i) == 1
        correct_answer = display_attended(i);
    else
        correct_answer = display_unattended(i);
    end

    %Update the counters
    if answer == correct_answer
        mistake = 0;
        if question_about_attended(i) == 1
            number_correct_attended = number_correct_attended + 1;
            if answer == 1
                allData.number_attended_hit = allData.number_attended_hit + 1;
                attended_current.hits = attended_current.hits + 1;
            else
                allData.number_attended_cr = allData.number_attended_cr + 1;
                attended_current.cr = attended_current.cr + 1;
            end
        else
            number_correct_unattended = number_correct_unattended + 1;
            if answer == 1
                allData.number_unattended_hit = allData.number_unattended_hit + 1;
                unattended_current.hits = unattended_current.hits + 1;
            else
                allData.number_unattended_cr = allData.number_unattended_cr + 1;
                unattended_current.cr = unattended_current.cr + 1;
            end
        end
    else
        mistake = 1;
        if question_about_attended(i) == 1
            number_incorrect_attended = number_incorrect_attended + 1;
            if answer == 1
                allData.number_attended_fa = allData.number_attended_fa + 1;
                attended_current.fa = attended_current.fa + 1;
            else
                allData.number_attended_miss = allData.number_attended_miss + 1;
                attended_current.misses = attended_current.misses + 1;
            end
        else
            number_incorrect_unattended = number_incorrect_unattended + 1;
            if answer == 1
                allData.number_unattended_fa = allData.number_unattended_fa + 1;
                unattended_current.fa = unattended_current.fa + 1;
            else
                allData.number_unattended_miss = allData.number_unattended_miss + 1;
                unattended_current.misses = unattended_current.misses + 1;
            end
        end
    end

    %Update the number of incorrect responses and time
    number_incorrect = number_incorrect + mistake;

    %Save data
    presentation.answer(i) = answer;
    presentation.answer2(i) = answer2;
    presentation.rt(i) = rt;
    presentation.made_mistake(i) = mistake;
end

presentation.contrast = contrast;
presentation.which_contrast = which_contrast;
presentation.contrast_shown = contrast_shown;
presentation.number_incorrect = number_incorrect;
presentation.percent_incorrect_attended = number_incorrect_attended/(number_incorrect_attended+number_correct_attended);
presentation.percent_incorrect_unattended = number_incorrect_unattended/(number_incorrect_unattended+number_correct_unattended);;
presentation.question_about_attended = question_about_attended;
presentation.cued_diagonal = cued_diagonal;
presentation.allData = allData;

Screen('Close');