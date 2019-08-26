function Recieved = SendCommand(app)

    if isempty(app.Commands)
        app.Commands = [app.Commands CreateCommand(0, app)];
    end

    
    fwrite(app.Socket, app.Commands(1));
    commandsent = strcat("Sent: ", app.Commands(1))
    commandsent = char(commandsent)
    % app.Console.Value = {app.Console.Value , strcat('Sent: ',app.Commands(1))};
    UpdateConsole(app, commandsent);
    app.Commands(1) = [];
    
    pause(1);

    Recieved = fgetl(app.Socket);
    
end