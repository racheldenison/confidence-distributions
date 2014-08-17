% run_study

try

    clear
    
    skip_instructions = 0;
    
    %Open window and do useful stuff
    [window,width,height] = openScreen();

    Screen('TextFont',window, 'Arial');
    Screen('TextSize',window, 20);
    Screen('FillRect', window, 127);
    wrapat = 60;

    block_size = 40;

    allData.number_attended_fa = 0;
    allData.number_attended_cr = 0;
    allData.number_attended_hit = 0;
    allData.number_attended_miss = 0;
    allData.number_unattended_fa = 0;
    allData.number_unattended_cr = 0;
    allData.number_unattended_hit = 0;
    allData.number_unattended_miss = 0;

    %Get current time
    current_time = clock;
    text_results = ['results' num2str(current_time(3)) '_' num2str(current_time(4)) '_' num2str(current_time(5)) ''];
   
    %Give some initial instructions and practice trials
    if ~skip_instructions
        initial_instructions(window, width, height);
    end
   
    %Set the contrast levels
%     contrast = [.06 .08 .1 .12];   
    contrast = [.01 .02 .04 .08];
    
    %Instructions
    text = 'Very good. We are now ready to begin the experiment. It will look exactly as the last few training blocks that you just completed. You will see your performance after each block, so try to keep it as high as possible.\n\nDon''t forget to always fixate on the red square in the middle!\n\nYou will have 4 runs of 6 blocks each. Each block will consist of 40 trials, like in the practice. You will have 15 seconds of rest after each block and will be able to take as much rest as you need between runs.\n\nNB! Don''t forget to use all 4 visibility ratings!.\n\nPress any key to start with the experiment!';
    DrawFormattedText(window, text, 300, 'center', 255, wrapat);
    Screen('Flip',window);
    WaitSecs(1);
    KbWait;

    %Start sequence of runs
    for run_number=1:4

        for block_number=1:6

            %Instructions
            number_run_string = num2str(run_number);
            number_block_string = num2str(block_number);
            text_run = ['RUN ' number_run_string '  (out of 4)'];
            text_block = ['BLOCK ' number_block_string '  (out of 6)'];
            DrawFormattedText(window, text_run, 'center',height/2-60, 255);
            DrawFormattedText(window, text_block, 'center',height/2-30, 255);
            Screen('Flip',window);
            WaitSecs(5);

            %Display the block
            data{(run_number-1)*6+block_number} = one_block(window, width, height, contrast, block_size, .7, allData);

            %Start the updating after the first iteration
            allData = data{(run_number-1)*6+block_number}.allData;

            %Feedback
            percent_mistakes_made = 100*data{(run_number-1)*6+block_number}.number_incorrect/block_size;
            mistakes = num2str(100*data{(run_number-1)*6+block_number}.number_incorrect/block_size);
            message = ['In this block you answered incorrectly on ' mistakes '% of the questions'];
            Screen ('DrawText', window, message, width/2-200, height/2-50, 255);

            if block_number == 6
                Screen ('DrawText', window, 'Take a break. Press any key when ready to continue with the next run.', width/2-200, height/2 + 50, 255);
            else
                Screen ('DrawText', window, 'You have 15 seconds before the next block starts.', width/2-200, height/2 + 50, 255);
            end
            Screen('Flip',window);
            if block_number == 6
                WaitSecs(1);
                KbWait;
            else
                WaitSecs(10);
            end

            eval(['save ' text_results ' data']);
        end   
    end

    DrawFormattedText(window, 'All done! Please, call the experimenter.','center','center', 255);
    Screen('Flip',window);
    WaitSecs(5);
    KbWait;

    %End. Close all windows
    Screen('CloseAll');

catch
    Screen('CloseAll');
    psychrethrow(psychlasterror);
end