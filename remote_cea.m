function remote_cea(input_path, output_path)
    % Remote CEA
    % A dity file, full of the black arts of MATLAB Networking
    % Parameters
    % input_path: path to Detn.inp
    % output_path: path to Detn.out
    % IP and port are hardcoded. They'll probably break. A lot

    %% WARNING %%
    % HEREIN CONTAINED IS THE DARK ART OF MATLAB NETWORKING
    % SHOULD YOU VALUE YOUR SANITY, STAY AWAY
    
    ip = '40.78.128.46';    % Remote machine
    % ip = '10.104.37.246'; % LXC container for testing
    port = 2000;

    in_file  = fopen(input_path, 'r');
    if in_file < 0
        error('Failed to open %s', input_path)
    end

    out_file = fopen(output_path, 'w');
    if in_file < 0
        error('Failed to open %s', output_path)
    end

    fprintf('Calling %s:%d ', ip, port)
    socket = tcpclient(ip, port, 'Timeout', 10);
    fprintf('Ok. ')

    fprintf('Sending %s ', input_path)
    data = fgets(in_file);
    % write(socket, uint8(data));
    while data ~= -1
        write(socket, uint8(data));
        data = fgets(in_file);
    end
    write(socket, uint8(10)); % newline = 10 = 0x0A

    % MATLAB will run ahead and try to run things incorrectly
    % java.lang.Thread.sleep(100);

    fprintf('Reading to %s\n', output_path);

    output = strcat(read(socket, 1));
    ismore = true;
    while ismore
        output = strcat(output, read(socket, socket.BytesAvailable));
        ismore = isempty(findstr(output, 'TRANSMISSION DONE'));
    end
    fprintf(out_file, '%s', output);

    socket.delete;
    fclose(in_file);
    fclose(out_file);
end
