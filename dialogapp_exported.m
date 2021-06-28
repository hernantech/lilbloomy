classdef dialogapp_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure              matlab.ui.Figure
        TickerEditField       matlab.ui.control.EditField
        TickerEditFieldLabel  matlab.ui.control.Label
        Button                matlab.ui.control.Button
    end


    properties (Access = private) 
        CallingApp   % Main app object
        %ticker
            
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function StartupFcn(app, mainapp, ticker)
            % Store main app in property for CloseRequestFcn to use
            app.CallingApp = mainapp; 
            % Update UI with input values
            %note that the variable 'sz' is actually 'ticker' from
            %mainappexample.mlapp
            app.TickerEditField.Value = app.CallingApp.CurrentTicker;
            %app.DropDown.Value = c;
        end

        % Button pushed function: Button
        function ButtonPushed(app, event)
            % Call main app's public function
            ticker = app.TickerEditField.Value;
            updateplot(app.CallingApp, ticker);
            
            % Delete the dialog box
            delete(app)
        end

        % Close request function: UIFigure
        function DialogAppCloseRequest(app, event)
            % Enable the Plot options button in main app
            app.CallingApp.OptionsButton.Enable = 'on';
            
            % Delete the dialog box 
            delete(app);
        end

        % Value changing function: TickerEditField
        function TickerEditFieldValueChanging(app, event)
            changingValue = event.Value;
            app.CurrentTicker = changingValue;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [600 100 392 248];
            app.UIFigure.Name = 'Options';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @DialogAppCloseRequest, true);

            % Create Button
            app.Button = uibutton(app.UIFigure, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.Button.Position = [116 43 174 22];
            app.Button.Text = '<GO>';

            % Create TickerEditFieldLabel
            app.TickerEditFieldLabel = uilabel(app.UIFigure);
            app.TickerEditFieldLabel.HorizontalAlignment = 'right';
            app.TickerEditFieldLabel.Position = [120 155 38 22];
            app.TickerEditFieldLabel.Text = 'Ticker';

            % Create TickerEditField
            app.TickerEditField = uieditfield(app.UIFigure, 'text');
            app.TickerEditField.ValueChangingFcn = createCallbackFcn(app, @TickerEditFieldValueChanging, true);
            app.TickerEditField.Placeholder = 'SPY';
            app.TickerEditField.Position = [173 155 100 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = dialogapp_exported(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)StartupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end